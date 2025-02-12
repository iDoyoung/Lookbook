import XCTest
import Testing
import CoreLocation
import WeatherKit
import Photos

@testable import Lookbook

class TodayInteractorTests: XCTestCase {
    
    var sut: TodayInteractor!
    var weatherRepositorySpy: WeatherRepositorySpy!
    var photosWorkerSpy: PhotosWorkerSpy!
    var locationServiceSpy: LocationServiceSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        weatherRepositorySpy = WeatherRepositorySpy()
        photosWorkerSpy = PhotosWorkerSpy()
        locationServiceSpy = LocationServiceSpy()
        
        sut = TodayInteractor(
            photosWorker: photosWorkerSpy,
            weatherRepository: weatherRepositorySpy,
            locationService: locationServiceSpy
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        locationServiceSpy = nil
        photosWorkerSpy = nil
        weatherRepositorySpy = nil
        
        try super.tearDownWithError()
    }
    
    func test_execute_viewDidLoad_shouldRequestLocationAuthorization() async {
        // Given
        let model = TodayModel(locationState: locationServiceSpy.state)
        
        // When
        let _ = await sut.execute(action: .viewDidLoad, with: model)
        
        // Then
        XCTAssertTrue(locationServiceSpy.requestAuthorizationCalled)
        XCTAssertTrue(locationServiceSpy.requestLocationCalled)
    }

    func test_execute_requestWeather_withValidLocation_shouldUpdateWeatherAndLocationName() async {
        // Given
        let mockLocation = CLLocation(latitude: 37.5665, longitude: 126.9780)
        locationServiceSpy.state.location = mockLocation
        let model = TodayModel(locationState: locationServiceSpy.state)
       
        //  When
        let updatedModel = await sut.execute(action: .updateWeather, with: model)
        
        // Then
        XCTAssertTrue(weatherRepositorySpy.calledRequestWeather)
    }
    
    func test_execute_requestWeather_withNoLocation_shouldNotUpdateWeather() async {
        // Given
        let model = TodayModel(locationState: locationServiceSpy.state)
        
        // When
        let updatedModel = await sut.execute(action: .updateWeather, with: model)
        
        // Then
        XCTAssertNil(updatedModel.weather)
        XCTAssertFalse(weatherRepositorySpy.calledRequestWeather)
    }
    
}
   
@Test("Update Weather시 Photos Worker 호출")
func updateWeather() async {
    // Given
    let weatherRepositorySpy = WeatherRepositorySpy()
    let photosWorkerSpy = PhotosWorkerSpy()
    let locationServiceSpy = LocationServiceSpy()
    locationServiceSpy.state.location = .newYork
    let model = TodayModel(locationState: locationServiceSpy.state)
    
    let sut = TodayInteractor(
        photosWorker: photosWorkerSpy,
        weatherRepository: weatherRepositorySpy,
        locationService: locationServiceSpy
    )
    
    // When
    let expected = await sut.execute(action: .updateWeather, with: model)
    
    // Then
    #expect(photosWorkerSpy.fetchPhotosAssetsCalled)
}
