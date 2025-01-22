import Foundation
import Photos

class DIContainer {
    
    
    //View Controller
    func createTodayViewController() -> TodayViewController {
        let router = createTodayRouter()
        let viewController = TodayViewController(
            model: createTodayModel(),
            interactor: createTodayInteractor(),
            router: router
        )
        router.destination = viewController
        return viewController
    }
     
    private func createTodayInteractor() -> TodayInteractable {
        return TodayInteractor(
            photosWorker: photosWorker,
            weatherRepository: weatherRepository,
            locationService: coreLocationService
        )
    }
    
    private func createTodayModel() -> TodayModel {
        return TodayModel(
            locationState: locationServiceState,
            photosState: photosState
        )
    }
    
    private func createTodayRouter() -> TodayRouter {
        return TodayRouter(container: self)
    }
    
    func createTodayWeatherViewController() -> TodayWeatherViewController {
        return TodayWeatherViewController(
            model: createTodayWeatherModel(),
            interactor: createTodayWeatherInteractor()
        )
    }
    
    private func createTodayWeatherModel() -> TodayWeatherModel {
        return TodayWeatherModel(
            locationState: locationServiceState,
            photosState: photosState
        )
    }
    
    private func createTodayWeatherInteractor() -> TodayWeatherInteractable {
        return TodayWeatherInteractor(
            weatherRepository: weatherRepository
        )
    }
    
    func createDetailsViewController(asset: PHAsset?, weather: DailyWeather?) -> DetailsViewController {
        return DetailsViewController(
            model: createDetailsModel(
                phAsset: asset,
                weather: weather
            )
        )
    }
    
    func createDetailsModel(phAsset: PHAsset?, weather: DailyWeather?) -> DetailsModel {
        DetailsModel(
            asset: phAsset,
            weather: weather
        )
    }
    
    // Service
    
    private lazy var locationServiceState: LocationServiceState = LocationServiceState()
    
    private func createLocationServiceState() -> LocationServiceState{
        return LocationServiceState()
    }
    
    private lazy var photosState: PhotosState = PhotosState()
    
    private func createPhotosState() -> PhotosState {
        return PhotosState()
    }
    
    private lazy var coreLocationService: CoreLocationServiceProtocol = createCoreLocationService(with: locationServiceState)
    
    private func createCoreLocationService(with state: LocationServiceState) -> CoreLocationServiceProtocol {
        return CoreLocationService(state: state)
    }
    
    private lazy var photosWorker: PhotosWorking = createPhotosWorker()
   
    private func createPhotosWorker() -> PhotosWorking {
        return PhotosWorker()
    }
    
    private lazy var weatherRepository: WeatherRepository = WeatherRepository()
    
    private func createWeatherRepository() -> WeatherRepository {
        return WeatherRepository()
    }
}
