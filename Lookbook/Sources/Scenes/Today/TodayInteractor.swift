import Foundation
import Combine
import CoreLocation
import Photos
import os

enum TodayViewAction {
    case viewDidLoad, viewWillAppear, viewIsAppearing, updatedCurrentLocation
}
                              
protocol TodayInteractable: AnyObject {
    func execute(action: TodayViewAction, with model: TodayModel) async -> TodayModel
}

final class TodayInteractor: TodayInteractable {
    
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.TodayInteractor", category: "Interactor")
    private var cancellableBag = Set<AnyCancellable>()
    
    // service
    var photosWorker: PhotosWorking
    var weatherRepository: WeatherRepositoryProtocol
    var locationService: CoreLocationServiceProtocol
   
    init(
        photosWorker: PhotosWorking = PhotosWorker(),
        weatherRepository: WeatherRepositoryProtocol = WeatherRepository(),
        locationService: CoreLocationServiceProtocol = CoreLocationService()
    ) {
        self.photosWorker = photosWorker
        self.weatherRepository = weatherRepository
        self.locationService = locationService
    }
    
    func execute(action: TodayViewAction, with model: TodayModel) async -> TodayModel {
        logger.log("Execute \(String(describing: action))")
        
        switch action {
        case .viewDidLoad:
            break
        case .viewWillAppear:
            model.locationState = await model.locationState
                .authorizationStatus(locationService.requestAuthorization())
                .currentLocation(locationService.requestLocation())
            model.photosState = await model.photosState
                .authorizationStatus(photosWorker.requestAuthorizationStatus())
                .assets(photosWorker.fetchPhotosAssets())
        case .viewIsAppearing:
            break
        case .updatedCurrentLocation:
            if let location = model.locationState.location {
                do {
                    try await weatherRepository.requestWeather(for: location)
                    model.weather = weatherRepository[location]
                } catch {
                    logger.error("Apple Weather 요청 실패\n다음 에러: \(error)")
                }
            }
        }
        
        return model
    }
}
