import XCTest
import CoreLocation
@testable import Lookbook

final class TodayInteractorTests: XCTestCase {

    var sut: TodayInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TodayInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Doubles
    var mockModel: TodayModel!
    class MockLocationService: CoreLocationServiceProtocol {
        
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var location = CLLocation(latitude: 0, longitude: 0)
        
        func requestLocation() async -> CLLocation {
            return location
        }
        
        func requestAuthorization() async -> CLAuthorizationStatus {
            return authorizationStatus
        }
    }
    
    // MARK: - Tests
    func test_requestLocationAuthorization_whenViewIsAppearing() async {
        
        // given
        mockModel = TodayModel()
        mockModel.locationState = LocationServiceState()
        
        // when
        let target = await sut.execute(action: .viewIsAppearing, with: mockModel)
        
        // then
        XCTAssertEqual(
            target.locationState!.authorizationStatus,
                .authorizedAlways
        )
    }
}
