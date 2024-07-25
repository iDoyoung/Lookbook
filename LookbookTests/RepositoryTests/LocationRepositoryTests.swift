import XCTest
import CoreLocation
@testable import Lookbook

final class LocationRepositoryTests: XCTestCase {

    // MARK: - System under test
    
    var sut: LocationRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreLocationServiceSpy = CoreLocationServiceSpy()
        sut = LocationRepository(service: coreLocationServiceSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        coreLocationServiceSpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Location 권한 요청시, Core location service 호출 여부 테스트
    func test_whenRequest() {
        // given
        
        // when
        sut.requestAuthorization()
        
        // then
        XCTAssertTrue(coreLocationServiceSpy.calledRequestAuthorization, "Core Location Service 호출")
    }
    
    /// Core location service에서 접근 권한 상태 변경 시, Location repository에서 같은 값으로 변경 테스트
    func test_whenChangedAuthorizationStatusFromCoreLocationService_shouldBeChangeAuthorizationStatus() {
        // given
        coreLocationServiceSpy.authorizationStatusSubject.send(.authorizedAlways)
       
        // then
        XCTAssertEqual(coreLocationServiceSpy.authorizationStatusSubject.value, sut.authorizationStatus.value, "Core location Service와 동일한 접근 권한 상태 변경")
    }
    
    /// Core location service 에서 위치 업데이트 시, Location repository의 Current location 업데이트 테스트
    func test_whenUpdatedLocationFromCoreLocationService_shouldBeUpdatedCurrentLocation() {
        
        // given
        let promise = expectation(description: "Updated Location")
        
        let mockLatitue: CLLocationDegrees = 37.33483990328966
        let mockLongitude: CLLocationDegrees = -122.00896129006036
        let mockLocation = CLLocation(
            latitude: mockLatitue,
            longitude: mockLongitude)
        
        
        let mockLocationInfo = LocationInfo(location: mockLocation)
        
        // then
        sut.currentLocation.sink {
            if $0 != nil {
                promise.fulfill()
            }
        }
        .cancel()
        
        coreLocationServiceSpy.locationSubject.send(mockLocation)
        
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(mockLocationInfo, self.sut.currentLocation.value, "업데이트 된 현재위치와 동일")
    }
    
    // MARK: - Test doubles
    var coreLocationServiceSpy: CoreLocationServiceSpy!
}
