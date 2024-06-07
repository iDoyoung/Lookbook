import XCTest
@testable import Lookbook

final class LocationUseCaseTests: XCTestCase {
    
    // MARK: - System under test
    var sut: LocationUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        locationRepositorySpy = LocationRepositorySpy()
        sut = LocationUseCase(repository: locationRepositorySpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        locationRepositorySpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    ///권한 요청 실행
    func test_whenExecuteRequest_shouldCallRequestAuthorization() {
        // given
        
        // when
        sut.executeRequestAuthorization()
        
        // then
        XCTAssertTrue(locationRepositorySpy.calledRequestAuthorization, "Location Repository 호출 성공")
    }
    
    // MARK: - Test doubles
    var locationRepositorySpy: LocationRepositorySpy!
}
