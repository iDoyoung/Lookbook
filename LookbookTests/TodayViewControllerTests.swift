import XCTest
import CoreLocation
@testable import Lookbook

final class TodayViewControllerTests: XCTestCase {

    // System Under Test
    
    var sut: TodayViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        requestLocationAuthorizationUseCaseSpy = RequestLocationAuthorizationUseCaseSpy()
        getLocationAuthorizationUseCaseSpy = GetLocationAuthorizationUseCaseSpy()
        photosUseCaseSpy = PhotosUseCaseSpy()
        getCurrentLocationUseCaseSpy = GetCurrentLocationUseCaseSpy()
        
        sut = TodayViewController()
        sut.requestLocationAuthorizationUseCase = requestLocationAuthorizationUseCaseSpy
        sut.getLocationAuthorizationLocationUseCase = getLocationAuthorizationUseCaseSpy
        sut.photosUseCase = photosUseCaseSpy
        sut.getCurrentLocationUseCase = getCurrentLocationUseCaseSpy
    }

    override func tearDownWithError() throws {
        photosUseCaseSpy = nil
        requestLocationAuthorizationUseCaseSpy = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Tests
    
    /// 뷰 Did Load 시 Photos Use Case 호출 여부 테스트
    func test_whenViewDidLoad_shouldCallUseCase() async {
        
        // given
        photosUseCaseSpy.mockPhotosAuthStatus = .notDetermined
        
        // when
        let task = Task {
            await sut.viewDidLoad()
        }
        
        await task.value
        
        // then
        XCTAssertTrue(photosUseCaseSpy.calledUseCase, "Photos Use Case 호출")
    }
    
    /// 뷰, did load 시,  Get CurrentLocation Use Case 호출 여부 테스트
    func test_whenViewDidLoad_shouldCellGetCurrentLocationUseCase() {
        // given
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(getCurrentLocationUseCaseSpy.calledExecute)
    }
   
    /// Request Location Authorization Use Case 호출 여부 테스트
    func test_whenRequestLocationAuthorization_shouldCallLocationUseCase() {
        // given
        
        // when
        sut.requestLocationAuthorization()
        
        // then
        XCTAssert(requestLocationAuthorizationUseCaseSpy.calledExecute, "Request Location Authorization Use Case 호출")
    }
    
    /// Get Location Authorization Use Case 호출 여부 테스트
    func test_whenViewDidLoad_shouldBeCallGetLocationAuthorizationUseCase() {
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(getLocationAuthorizationUseCaseSpy.calledExecute, "Get Location Authorization Use Case 호출")
    }
    
    // Test doubles
    private var requestLocationAuthorizationUseCaseSpy: RequestLocationAuthorizationUseCaseSpy!
    private var getLocationAuthorizationUseCaseSpy: GetLocationAuthorizationUseCaseSpy!
    private var photosUseCaseSpy: PhotosUseCaseSpy!
    private var getCurrentLocationUseCaseSpy: GetCurrentLocationUseCaseSpy!
}
