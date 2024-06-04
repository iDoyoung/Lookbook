import XCTest
import CoreLocation
@testable import Lookbook

final class TodayViewControllerTests: XCTestCase {

    // System Under Test
    
    var sut: TodayViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        locationManagerSpy = LocationManagerSpy()
        photosUseCaseSpy = PhotosUseCaseSpy()
        
        sut = TodayViewController()
        sut.locationManager = locationManagerSpy
        sut.photosUseCase = photosUseCaseSpy
    }

    override func tearDownWithError() throws {
        photosUseCaseSpy = nil
        locationManagerSpy = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    // Test doubles
    var locationManagerSpy: LocationManagerSpy!
    var photosUseCaseSpy: PhotosUseCaseSpy!
    
    //MARK: - Tests
    func test_whenViewDidloadAndLocationAuthorizationStatusIsNotDetermined_mustCallRequestAuthorization() {
        
        // given
        locationManagerSpy?.authorizationStatus = .init(rawValue: 0)!
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(locationManagerSpy.requestAuthorizationIsCalled)
    }
    
    /// 뷰 Did Load 시 Photos Use Case 호출
    func test_whenViewDidLoad_shouldCallUseCase() async {
        
        // given
        photosUseCaseSpy.mockPhotosAuthStatus = .notDetermined
        
        // when
        let task = Task {
            await sut.viewDidLoad()
        }
        
        await task.value
        
        // then
        XCTAssertTrue(photosUseCaseSpy.calledUseCase, "Photos Use Case 호출 성공")
    }
}
