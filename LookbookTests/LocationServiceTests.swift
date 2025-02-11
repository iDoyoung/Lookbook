import XCTest
import CoreLocation

@testable import Lookbook

final class LocationServiceTests: XCTestCase {
    
    var sut: CoreLocationService!
    var state: LocationServiceState!
    var fetcher: MockLocationFetcher!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        state = LocationServiceState()
        fetcher = MockLocationFetcher()
        fetcher.location = mockLocation
        
        sut = CoreLocationService(
            state: state,
            locationFetcher: fetcher
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        fetcher = nil
        state = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    
    let mockLocation = CLLocation(
        latitude: 37.3293,
        longitude: -121.8893
    )
    
    var mockAuthorizationStatus: CLAuthorizationStatus!
    
    enum MockError: Error {
        case locationUnavailable
        case permissionDenied
        case unknownError
    }
    
    class MockLocationFetcher: LocationFetcher {
        
        weak var locationFetcherDelegate: LocationFetcherDelegate?
        
        var error: MockError?
        var location: CLLocation?
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        
        var isCallRequestLocation = false
        var isCallRequestWhenInUseAuthorization: Bool = false
        var isCallStartUpdatingLocation: Bool = false
        
        func requestLocation() {
            if let error {
                locationFetcherDelegate!.locationFetcher(self, didFailWithError: error)
                return
            }
            locationFetcherDelegate!.locationFetcher(self, didUpdate: [location!])
            isCallRequestLocation = true
        }
        
        func requestWhenInUseAuthorization() {
            locationFetcherDelegate!.locationManagerDidChangeAuthorization(authorizationStatus)
            isCallRequestWhenInUseAuthorization = true
        }
        
        func startUpdatingLocation() {
            locationFetcherDelegate!.locationFetcher(self, didUpdate: [location!])
            isCallStartUpdatingLocation = true
        }
        
        func stopUpdatingLocation() {
            if let error {
                locationFetcherDelegate!.locationFetcher(self, didFailWithError: error)
            }
        }
    }
    
    //MARK: - Tests
    
    func test_requestLocation_shouldUpdateStateWithNewLocation() {
        // When
        sut.requestLocation()
        
        // Then
        XCTAssertEqual(sut.state.location, mockLocation)
        XCTAssertTrue(fetcher.isCallStartUpdatingLocation)
    }
    
    func test_requestLocation_whenFetcherFailsWithError_shouldNotUpdateLocation() {
        // Given
        fetcher.error = .locationUnavailable
        
        // When
        sut.requestLocation()
        
        // Then
        XCTAssertFalse(fetcher.isCallRequestLocation)
        XCTAssertEqual(sut.state.location, mockLocation)
    }
    
    // MARK: - Authorization Tests
    
    func test_requestAuthorization_whenNotDetermined_shouldRequestAuthorization() {
        // Given
        fetcher.authorizationStatus = .notDetermined
        
        // When
        sut.requestAuthorization()
        
        // Then
        XCTAssertTrue(fetcher.isCallRequestWhenInUseAuthorization)
    }
    
    func test_requestAuthorization_whenAlreadyAuthorized_shouldNotRequestAgain() {
        // Given
        fetcher.authorizationStatus = .authorizedWhenInUse
        sut.state.authorizationStatus = .authorizedWhenInUse
        
        // When
        sut.requestAuthorization()
        
        // Then
        XCTAssertFalse(fetcher.isCallRequestWhenInUseAuthorization)
    }
    
    func test_whenAuthorizationChanges_shouldUpdateState() {
        // Given
        let newStatus: CLAuthorizationStatus = .authorizedWhenInUse
        
        // When
        fetcher.locationFetcherDelegate!.locationManagerDidChangeAuthorization(newStatus)
        
        // Then
        XCTAssertEqual(sut.state.authorizationStatus, newStatus)
    }
    
    func test_whenAuthorizationChangesToAuthorized_shouldRequestLocation() {
        // Given
        let newStatus: CLAuthorizationStatus = .authorizedWhenInUse
        
        // When
        fetcher.locationFetcherDelegate!.locationManagerDidChangeAuthorization(newStatus)
        
        // Then
        XCTAssertTrue(fetcher.isCallStartUpdatingLocation)
    }
    
    func test_whenLocationUpdates_shouldStopUpdatingLocation() {
        // When
        fetcher.locationFetcherDelegate!.locationFetcher(fetcher, didUpdate: [mockLocation])
        
        // Then
        XCTAssertEqual(sut.state.location, mockLocation)
    }
    
    // MARK: - Error Handling Tests
    
    func test_whenLocationUpdateFails_shouldNotUpdateState() {
        // Given
        let initialLocation = sut.state.location
        
        // When
        fetcher.locationFetcherDelegate!.locationFetcher(
            fetcher,
            didFailWithError: MockError.locationUnavailable
        )
        
        // Then
        XCTAssertEqual(sut.state.location, initialLocation)
    }
}
