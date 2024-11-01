import XCTest
import CoreLocation
import WeatherKit

@testable import Lookbook

final class TodayInteractorTests: XCTestCase {

    var sut: TodayInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TodayInteractor()
        mockModel = TodayModel()
        mockLocationServiceState = LocationServiceState()
        mockLocationService = MockLocationService()
        mockWeatherRepository = MockWeatherRepository()
        sut.locationService = mockLocationService
    }

    override func tearDownWithError() throws {
        sut = nil
        mockModel = nil
        mockLocationService = nil
        mockLocationServiceState = nil
        mockWeatherRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Doubles
    var mockModel: TodayModel!
    var mockLocationServiceState: LocationServiceState!
    var mockLocationService: MockLocationService!
    var mockWeatherRepository: MockWeatherRepository!
    
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
    
    class MockWeatherRepository: WeatherRepositoryProtocol {
        
        var mockCurrentlyWeather: CurrentlyWeather?
        var calledRequestWeahter: Bool = false
        var calledRequestWeahterWithDateRange: Bool = false
        
        subscript(location: CLLocation) -> Lookbook.CurrentlyWeather? {
            return mockCurrentlyWeather
        }
        
        subscript(location: CLLocation) -> [Lookbook.DailyWeather]? {
            return []
        }
        
        @discardableResult
        func requestWeather(for location: CLLocation) async throws -> Weather {
            calledRequestWeahter.toggle()
            return Weather(from: Data() some Decoder)
        }
        
        @discardableResult
        func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [Lookbook.DailyWeather] {
            calledRequestWeahterWithDateRange.toggle()
            return []
        }
    }
    
    // MARK: - Tests
    func test_executeInteractor_whenViewWillAppear_shouldBeSetAuthorizationStatusAndCurrentLocationOfLocationServiceState() async {
        
        // given
        mockLocationService.authorizationStatus = .authorizedWhenInUse
        mockModel.locationState = mockLocationServiceState
        
        // when
        let _ = await sut.execute(action: .viewWillAppear, with: mockModel)
        
        // then
        XCTAssertEqual(
            mockModel.locationState!.authorizationStatus!,
            .authorizedWhenInUse
        )
        
        XCTAssertEqual(
            mockModel.locationState!.location!,
            mockLocationService.location
        )
    }
}
