import XCTest
@testable import Lookbook

final class PhotosRepositoryTests: XCTestCase {
    
    // System under test
    var sut: PhotosRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        photosServiceSpy = PhotosServiceSpy()
        sut = PhotosRepository(photosService: photosServiceSpy)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        photosServiceSpy = nil
        
        try super.tearDownWithError()
    }
    
    // - MARK: Test doubles
    var photosServiceSpy: PhotosServiceSpy!
    
    // - MARK: Tests
    
    /// Photos 접근 권힌을 설정하지 않았을 경우
    func test_whenReadPhotosAuthorizationStatusAndReturnNotDetermined_shouldBeCallPhotosService() async throws {
        
        // given
        photosServiceSpy.mockAuthorizationStatus = .notDetermined
        
        // when
        let authorizationStatus = try await sut.authorizationStatus
        
        // then
        XCTAssertTrue(photosServiceSpy.calledGetAuthorizationStatus, "성공적으로 Service를 호출")
        XCTAssertEqual(photosServiceSpy.mockAuthorizationStatus, authorizationStatus, "성공적으로 권한 접근: \(String(describing: authorizationStatus))")
    }
    
    /// Photos 접근 권힌을 거절된 경우
    func test_whenReadPhotosAuthorizationStatusAndReturnDenied_shouldBeCallPhotosService() async throws {
        
        // given
        photosServiceSpy.mockAuthorizationStatus = .denied
        
        // when
        let authorizationStatus = try await sut.authorizationStatus
        
        // then
        XCTAssertTrue(photosServiceSpy.calledGetAuthorizationStatus, "성공적으로 Service를 호출")
        XCTAssertEqual(photosServiceSpy.mockAuthorizationStatus, authorizationStatus, "성공적으로 권한 접근: \(String(describing: authorizationStatus))")
    }
    
    /// Photos 접근 권힌을 일부 허가된 경우
    func test_whenReadPhotosAuthorizationStatusAndReturnLimited_shouldBeCallPhotosService() async throws {
    
        // given
        photosServiceSpy.mockAuthorizationStatus = .limited
        
        // when
        let authorizationStatus = try await sut.authorizationStatus
        
        // then
        XCTAssertTrue(photosServiceSpy.calledGetAuthorizationStatus, "성공적으로 Service를 호출")
        XCTAssertEqual(photosServiceSpy.mockAuthorizationStatus, authorizationStatus, "성공적으로 권한 접근: \(String(describing: authorizationStatus))")
    }
    
    /// Photos 접근 권힌을 일부 허가된 경우
    func test_whenReadPhotosAuthorizationStatusAndReturnAuthorized_shouldBeCallPhotosService() async throws {
        
        // given
        photosServiceSpy.mockAuthorizationStatus = .authorized
        
        // when
        let authorizationStatus = try await sut.authorizationStatus
        
        // then
        XCTAssertTrue(photosServiceSpy.calledGetAuthorizationStatus, "성공적으로 Service를 호출")
        XCTAssertEqual(photosServiceSpy.mockAuthorizationStatus, authorizationStatus, "성공적으로 권한 접근: \(String(describing: authorizationStatus))")
    }
}
