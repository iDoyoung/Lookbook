import XCTest
@testable import Lookbook

final class TodayWeatherInteractorTests: XCTestCase {

    var sut: TodayWeatherInteractor!
    var weatherRepositorySpy: WeatherRepositorySpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        weatherRepositorySpy = WeatherRepositorySpy()
        sut = TodayWeatherInteractor(weatherRepository: weatherRepositorySpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        weatherRepositorySpy = nil
        try super.tearDownWithError()
    }
    
    func test_execute_whenViewDidLoadWithValidLocation_shouldUpdateWeather() async {
        // Given
        let model = TodayWeatherModel(locationState: LocationServiceState(), photosState: PhotosState())
        model.locationState.location = .init(latitude: 0, longitude: 0)
        // When
        let updatedModel = await sut.execute(action: .viewDidLoad, with: model)
        
        // Then
        XCTAssertNotNil(updatedModel.weather)
        XCTAssertEqual(updatedModel.weather?.current?.condition, CurrentlyWeather.stub().current?.condition)
    }
    
    func test_execute_whenViewDidLoadWithInvalidLocation_shouldUpdateWeather() async {
        // Given
        let model = TodayWeatherModel(locationState: LocationServiceState(), photosState: PhotosState())
        // When
        let updatedModel = await sut.execute(action: .viewDidLoad, with: model)
        
        // Then
        XCTAssertNil(updatedModel.weather)
    }
}
