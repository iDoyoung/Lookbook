import XCTest
@testable import Lookbook

final class LocationRepositoryTests: XCTestCase {

    // MARK: - System under test
    
    var sut: LocationRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreLocationServiceSpy = CoreLocationServiceSpy()
        sut = LocationRepository(service: coreLocationServiceSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        coreLocationServiceSpy = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Core Location 권한 요청
    func test_whenRequest() {
        // given
        
        // when
        sut.requestAuthorization()
        
        // then
        XCTAssertTrue(coreLocationServiceSpy.calledRequestAuthorization, "Core Location Service 호출 성공")
    }
    
    // MARK: - Test doubles
    var coreLocationServiceSpy: CoreLocationServiceSpy!
}
