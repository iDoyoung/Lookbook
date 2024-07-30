import XCTest
import CoreLocation
@testable import Lookbook

//final class TodayViewControllerTests: XCTestCase {
//
//    // System Under Test
//    
//    var sut: TodayViewController!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        requestLocationAuthorizationUseCaseSpy = RequestLocationAuthorizationUseCaseSpy()
//        getLocationAuthorizationUseCaseSpy = GetLocationAuthorizationUseCaseSpy()
//        photosUseCaseSpy = PhotosUseCaseSpy()
//        
//        locationRepositorySpy = LocationRepositorySpy()
//        
//        sut = TodayViewController()
//        sut.locationRepository = locationRepositorySpy
//        
//        sut.photosUseCase = photosUseCaseSpy
//    }
//
//    override func tearDownWithError() throws {
//        photosUseCaseSpy = nil
//        locationRepositorySpy = nil
//        sut = nil
//        try super.tearDownWithError()
//    }
//    
//    //MARK: - Tests
//    
//    /// 뷰 Did Load 시 Photos Use Case 호출 여부 테스트
//    func test_whenViewDidLoad_shouldCallUseCase() async {
//        
//        // given
//        photosUseCaseSpy.mockPhotosAuthStatus = .notDetermined
//        
//        // when
//        let task = Task {
//            await sut.viewDidLoad()
//        }
//        
//        await task.value
//        
//        // then
//        XCTAssertTrue(photosUseCaseSpy.calledUseCase, "Photos Use Case 호출")
//    }
//    
//    /// 뷰, did load 시,  Get CurrentLocation Use Case 호출 여부 테스트
////    func test_whenViewDidLoad_shouldCellGetCurrentLocationUseCase() {
////        // given
////        
////        // when
////        sut.viewDidLoad()
////        
////        // then
////        XCTAssertTrue(getCurrentLocationUseCaseSpy.calledExecute)
////    }
//   
//    /// Request Location Authorization시,  Location Repository 호출 여부 테스트
//    func test_whenRequestLocationAuthorization_shouldCallLocationUseCase() {
//        // given
//        
//        // when
//        sut.requestLocationAuthorization()
//        
//        // then
//        XCTAssert(locationRepositorySpy.calledRequestAuthorization, "Request Location Authorization Use Case 호출")
//    }
//    
//    /// View Did Load시, Location Repository 호출 여부 테스트
//    func test_whenViewDidLoad_shouldBeCallGetLocationAuthorizationUseCase() {
//        
//        let mockLatitue: CLLocationDegrees = 37.33483990328966
//        let mockLongitude: CLLocationDegrees = -122.00896129006036
//       
//        
//        let mockLocationInfo = LocationInfo(location: CLLocation(
//            latitude: mockLatitue,
//            longitude: mockLongitude))
//        
//        locationRepositorySpy.currentLocation.send(mockLocationInfo)
//        // when
//        sut.viewDidLoad()
//        
//        // then
//        
//    }
//    
//    // Test doubles
//    private var locationRepositorySpy: LocationRepositorySpy!
//    private var requestLocationAuthorizationUseCaseSpy: RequestLocationAuthorizationUseCaseSpy!
//    private var getLocationAuthorizationUseCaseSpy: GetLocationAuthorizationUseCaseSpy!
//    private var photosUseCaseSpy: PhotosUseCaseSpy!
//}
