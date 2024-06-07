import XCTest
import CoreLocation
@testable import Lookbook

final class TodayViewControllerTests: XCTestCase {

    // System Under Test
    
    var sut: TodayViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        locationUseCaseSpy = LocationUseCaseSpy()
        photosUseCaseSpy = PhotosUseCaseSpy()
        
        sut = TodayViewController()
        sut.locationUseCase = locationUseCaseSpy
        sut.photosUseCase = photosUseCaseSpy
    }

    override func tearDownWithError() throws {
        photosUseCaseSpy = nil
        locationUseCaseSpy = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    // Test doubles
    var locationUseCaseSpy: LocationUseCaseSpy!
    var photosUseCaseSpy: PhotosUseCaseSpy!
    
    //MARK: - Tests
    
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
    
    /// Location 권한 요청
    func test_whenRequestLocationAuthorization_shouldCallLocationUseCase() {
        // given
        
        // when
        sut.requestLocationAuthorization()
        
        // then
        XCTAssert(locationUseCaseSpy.calledExecuteRequestAuthorization, "Location Use Case 호출 성공")
    }
}
