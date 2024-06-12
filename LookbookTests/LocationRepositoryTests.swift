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
    
    /// Location 권한 요청시, Core location service 호출 여부 테스트
    func test_whenRequest() {
        // given
        
        // when
        sut.requestAuthorization()
        
        // then
        XCTAssertTrue(coreLocationServiceSpy.calledRequestAuthorization, "Core Location Service 호출")
    }
    
    /// Core location service에서 접근 권한 상태 변경 시, Location repository에서 같은 값으로 변경 테스트
    func test_whenChangedAuthorizationStatusFromCoreLocationService_shouldBeChangeAuthorizationStatus() {
        // given
        coreLocationServiceSpy.authorizationStatusSubject.send(.authorizedAlways)
       
        // then
        XCTAssertEqual(coreLocationServiceSpy.authorizationStatusSubject.value, sut.authorizationStatus.value, "Core location Service와 동일한 접근 권한 상태 변경")
    }
    
    
    // MARK: - Test doubles
    var coreLocationServiceSpy: CoreLocationServiceSpy!
}
