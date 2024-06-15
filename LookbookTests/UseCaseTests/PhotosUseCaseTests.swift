import XCTest
@testable import Lookbook

final class PhotosUseCaseTests: XCTestCase {

    // System under test
    var sut: PhotosUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        photosRepositorySpy = PhotosRepositorySpy()
        sut =  PhotosUseCase(repository: photosRepositorySpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        photosRepositorySpy = nil
        try super.tearDownWithError()
    }
    
    // - MARK: Test doubles
    var photosRepositorySpy: PhotosRepositorySpy!

    // - MARK: Tests
    func test_whenExecuteUseCaseGivenAuthorizedStatus_shouldBeCallPhotosRepository_andReturnAllPhotosAuthStatus() async {
        
        // given
        photosRepositorySpy.authorizationStatus = .authorized
        
        // when
        let auth = await sut.execute()
        
        // then
        XCTAssertTrue(photosRepositorySpy.calledRepository, "Photos Repository 호출 성공")
        XCTAssertEqual(PhotosAuthStatus.all, auth, "테스트 성공")
    }
    
    func test_whenExecuteUseCaseGivenDenied_shouldBeCallPhotosRepository_andReturnRestrictedOrDeniedPhotosAuthStatus() async {
        
        // given
        photosRepositorySpy.authorizationStatus = .denied
        
        // when
        let auth = await sut.execute()
        
        // then
        XCTAssertTrue(photosRepositorySpy.calledRepository, "Photos Repository 호출 성공")
        XCTAssertEqual(PhotosAuthStatus.restrictedOrDenied, auth, "테스트 성공")
    }
    
    func test_whenExecuteUseCaseGivenNotDetermined_shouldBeCallPhotosRepository_andReuturnUnknownedPhotosStatus() async {
        
        // given
        photosRepositorySpy.authorizationStatus = .notDetermined
        
        // when
        let auth = await sut.execute()
        
        // then
        XCTAssertTrue(photosRepositorySpy.calledRepository, "Photos Repository 호출 성공")
        XCTAssertEqual(PhotosAuthStatus.unknowned, auth, "테스트 성공")
    }
    
    func test_whenExecuteUseCaseNotGiven_shouldBeCallPhotosRepository_andReuturnUnknownedPhotosStatus() async {
        
        // given
        photosRepositorySpy.authorizationStatus = nil
        
        // when
        let auth = await sut.execute()
        
        // then
        XCTAssertTrue(photosRepositorySpy.calledRepository, "Photos Repository 호출 성공")
        XCTAssertEqual(PhotosAuthStatus.unknowned, auth, "테스트 성공")
    }
    
    func test_whenExecuteUseCase_shouldBeCallPhotosRepository_andReuturnLimitedPhotosStatus() async {
        
        // given
        photosRepositorySpy.authorizationStatus = .limited
        
        // when
        let auth = await sut.execute()
        
        // then
        XCTAssertTrue(photosRepositorySpy.calledRepository, "Photos Repository 호출 성공")
        XCTAssertEqual(PhotosAuthStatus.limited, auth, "테스트 성공")
    }
    
    
}
