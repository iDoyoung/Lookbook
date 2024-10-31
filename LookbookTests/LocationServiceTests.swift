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
        sut = CoreLocationService(locationFetcher: fetcher)
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
            locationFetcherDelegate?.locationFetcher(self, didUpdate: [location!])
            isCallRequestLocation = true
        }
        
        func requestWhenInUseAuthorization() {
            locationFetcherDelegate?.locationManagerDidChangeAuthorization(authorizationStatus)
            isCallRequestWhenInUseAuthorization = true
        }
        
        func startUpdatingLocation() {
            locationFetcherDelegate?.locationFetcher(self, didUpdate: [location!])
            isCallStartUpdatingLocation = true
        }
        
        func stopUpdatingLocation() {   }
    }
    
    //MARK: - Tests
    
    func test_requestLocation_shouldBeUpdate_locationState_toMockLocation() async {
        
        // when
        let state = await sut.requestLocation()
        
        // then
        XCTAssertEqual(state, mockLocation)
        XCTAssertTrue(fetcher.isCallRequestLocation)
    }
    
    func test_requestAuthorization_shouldBeUpdate_locationState_toMockAuthStatus_andBeNotCallRequestWhenInUseAuthorization_whenAuthorizationIsNotAuthorizedWhenInUse() async {
        
        // given
        fetcher.authorizationStatus = .authorizedWhenInUse
        
        // when
        let state = await sut.requestAuthorization()
        
        // then
        XCTAssertEqual(state, .authorizedWhenInUse)
        XCTAssertFalse(fetcher.isCallRequestWhenInUseAuthorization)
    }
}
