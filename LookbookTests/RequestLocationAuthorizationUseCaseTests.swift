import XCTest
@testable import Lookbook

final class RequestLocationAuthorizationUseCaseTests: XCTestCase {
    
    // MARK: - System under test
    var sut: RequestLocationAuthorizationLocationUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        locationRepositorySpy = LocationRepositorySpy()
        sut = RequestLocationAuthorizationLocationUseCase(repository: locationRepositorySpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        locationRepositorySpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    ///Location 접근 권한 요청 실행 테스트
    func test_whenExecuteRequest_shouldCallRequestAuthorization() {
        // given
        
        // when
        sut.execute()
        
        // then
        XCTAssertTrue(locationRepositorySpy.calledRequestAuthorization, "Location Repository 호출")
    }
    
    // MARK: - Test doubles
    var locationRepositorySpy: LocationRepositorySpy!
}
