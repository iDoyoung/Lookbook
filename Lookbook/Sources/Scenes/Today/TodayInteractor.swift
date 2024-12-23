import Foundation
import Combine
import CoreLocation
import Photos
import os

enum TodayViewAction {
    case viewDidLoad, viewWillAppear, requestWeather
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
            locationService.requestAuthorization()
            locationService.requestLocation()
        case .viewWillAppear:
            model.photosState = await model.photosState
                .authorizationStatus(photosWorker.requestAuthorizationStatus())
                .assets(
                    photosWorker.fetchPhotosAssets(
                        startDate: model.dateRange.start,
                        endDate: model.dateRange.end
                    )
                )
        case .requestWeather:
            if let location = model.locationState.location {
                do {
                    try await weatherRepository.requestWeather(for: location)
                    await model.locationName = locationService.state.name(location)
                    model.weather = weatherRepository[location]
                    
                    if model.photosState.authorizationStatus == .authorized || model.photosState.authorizationStatus == .limited {
                        try await weatherRepository.requestWeathr(
                            for: location,
                            startDate: model.dateRange.start,
                            endDate: model.dateRange.end
                        )
                        model.lastYearWeathers = weatherRepository[location]
                    }
                } catch {
                    logger.error("Apple Weather 요청 실패\n다음 에러: \(error)")
                }
            } else {
                logger.log("updatedCurrentLocation 실패, locationState.location: \(String(describing:  model.locationState.location)) ")
            }
        }
        
        return model
    }
}
