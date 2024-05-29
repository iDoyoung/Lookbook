import XCTest
import CoreLocation
@testable import Lookbook

final class TodayViewControllerTests: XCTestCase {

    var sut: TodayViewController!
    
    // Test doubles
    var locationManagerSpy: LocationManagerSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        locationManagerSpy = LocationManagerSpy()
        sut = TodayViewController()
        sut.locationManager = locationManagerSpy
    }

    override func tearDownWithError() throws {
        locationManagerSpy = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Tests
    func test_whenViewDidloadAndLocationAuthorizationStatusIsNotDetermined_mustCallRequestAuthorization() {
        // given
        locationManagerSpy?.authorizationStatus = .init(rawValue: 0)!
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(locationManagerSpy.requestAuthorizationIsCalled)
    }
}
