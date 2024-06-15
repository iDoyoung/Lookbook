//
//  GetLocationAuthorizationUseCaseTests.swift
//  LookbookTests
//
//  Created by Doyoung on 6/12/24.
//

import XCTest
@testable import Lookbook

final class GetLocationAuthorizationUseCaseTests: XCTestCase {

    // System Under Test
    var sut: GetLocationAuthorizationStatusUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        locationRepositorySpy = LocationRepositorySpy()
        sut = GetLocationAuthorizationStatusUseCase(repository: locationRepositorySpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        locationRepositorySpy = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests
    
    func test_whenExecute_shouldBeChangeLocationAuthStatusInLocationRepository() {
        // when
        sut.execute { _ in }
        // then
        XCTAssertTrue(locationRepositorySpy.changedAuthorizationStatus, "Location Repository의 접근 권한 변경")
    }
    
    ///Use Case 실행시, Location Repository 접근 권한 테스트(.denied)
    func test_whenExecuteWithDeniedStatus_shouldBeUnauthorized() {
        // given
        locationRepositorySpy.authorizationStatus.send(.denied)
        // when
        sut.execute { status in
            XCTAssertEqual(status, .unauthorized, "Unauthorized 상태로 변환")
        }
        // then
    }
    
    ///Use Case 실행시, Location Repository 접근 권한 테스트(.authorizedAlways)
    func test_whenExecuteWithAuthorizedAlwaysStatus_shouldBeAuthorized() {
        // given
        locationRepositorySpy.authorizationStatus.send(.authorizedAlways)
        // when
        sut.execute { status in
            XCTAssertEqual(status, .authorized, "Authorized 상태로 변환")
        }
        // then
    }
    
    ///Use Case 실행시, Location Repository 접근 권한 테스트(.authorizedWhenInUse)
    func test_whenExecuteWithAuthorizedWhenInUseStatus_shouldBeAuthorized() {
        // given
        locationRepositorySpy.authorizationStatus.send(.authorizedWhenInUse)
        // when
        sut.execute { status in
            
            // then
            XCTAssertEqual(status, .authorized, "Authorized 상태로 변환")
        }
    }
    
    ///Use Case 실행시, Location Repository 접근 권한 테스트(.notDetermined)
    func test_whenExecuteWithNotDetermined_shouldBeUnauthorized() {
        // given
        locationRepositorySpy.authorizationStatus.send(.notDetermined)
        // when
        sut.execute { status in
            
            // then
            XCTAssertEqual(status, .unauthorized, "Unauthorized 상태로 변환")
        }
    }
    
    ///Use Case 실행시, Location Repository 접근 권한 테스트(.restricted)
    func test_whenExecuteWithRestricted_shouldBeUnauthorized() {
        // given
        locationRepositorySpy.authorizationStatus.send(.restricted)
        // when
        sut.execute { status in
            
            // then
            XCTAssertEqual(status, .unauthorized, "Unauthorized 상태로 변환")
        }
        
    }
    
    // Test Doubles
    var locationRepositorySpy: LocationRepositorySpy!
}
