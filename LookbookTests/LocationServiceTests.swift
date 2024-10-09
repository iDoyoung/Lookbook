import XCTest
import CoreLocation

@testable import Lookbook

final class LocationServiceTests: XCTestCase {
    
    var sut: CoreLocationService!
    var state: LocationServiceState!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        state = LocationServiceState()
        var fetcher = MockLocationFetcher()
        fetcher.mockLocation = mockLocation
        sut = CoreLocationService(state: state, locationFetcher: fetcher)
    }
    
    override func tearDownWithError() throws {
        sut = nil
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
    
    struct MockLocationFetcher: LocationFetcher {
        
        var mockError: MockError?
        var mockLocation: CLLocation?
        weak var locationFetcherDelegate: LocationFetcherDelegate?
        
        
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        
        func requestWhenInUseAuthorization() {
            locationFetcherDelegate?.locationManagerDidChangeAuthorization(self)
        }
        
        func startUpdatingLocation() {
            locationFetcherDelegate?.locationFetcher(self, didUpdate: [mockLocation!])
        }
        
        func stopUpdatingLocation() {   }
    }
    
    //MARK: - Tests
    
    func test_requestLocation_shouldBeUpdate_locationState_toMockLocation() async {
        // when
        let state = await sut.execute(.requestLocation, with: state)
        // then
        XCTAssertEqual(state.location, mockLocation)
    }
    
    func test_requestAuthorization_shouldBeUpdate_locationState_toMockAuthStatus_whenAuthorizationIsNotAuthorizedWhenInUse() {
        
        // when
        mockAuthorizationStatus = .notDetermined
        
        sut.requestAuthorization()
        
        // then
        XCTAssertEqual(state.authorizationStatus, mockAuthorizationStatus)
    }
}
