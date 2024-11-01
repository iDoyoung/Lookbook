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
    var photosWorker: PhotosWorker
    var weatherRepository: WeatherRepositoryProtocol
    var locationService: CoreLocationServiceProtocol
   
    init(
        photosWorker: PhotosWorker = PhotosWorker(),
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
            model.locationState = await model.locationState?
                .authorizationStatus(locationService.requestAuthorization())
                .currentLocation(locationService.requestLocation())
        case .viewIsAppearing:
            break
        case .updatedCurrentLocation:
            if let location = model.locationState?.location {
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
