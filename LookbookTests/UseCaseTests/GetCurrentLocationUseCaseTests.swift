import XCTest
import CoreLocation

@testable import Lookbook

class GetCurrentLocationUseCaseTests: XCTestCase {
    
    // System under test
    
    var sut: GetCurrentLocationUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        locationRepositorySpy = LocationRepositorySpy()
        sut = GetCurrentLocationUseCase(repository: locationRepositorySpy)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        locationRepositorySpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    // FIXME: Test 실패, 강제로 실패한 케이스도 성공으로 나타난다. 비동기 이슈로 파악
    func test_whenExecuteGetCurrentUseCase_shouldBeGetLocationNameWhenUpdatedCurrentLocation() {
        // given
        
        let mockLatitue: CLLocationDegrees = 37.33483990328966
        let mockLongitude: CLLocationDegrees = -122.00896129006036
        let mockLocation = CLLocation(
            latitude: mockLatitue,
            longitude: mockLongitude)
        
        locationRepositorySpy.currentLocation.value = mockLocation
        
        // when
        sut.execute { output in
            // then
            XCTAssertEqual(output, "X")
        }
    }
    
    // Test doubles
    var locationRepositorySpy: LocationRepositorySpy!
}
