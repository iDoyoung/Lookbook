import Foundation
import Combine
import CoreLocation
import Photos
import os
import WeatherKit
import FirebaseAnalytics

enum TodayViewAction {
    case viewDidLoad, viewWillAppear, updateWeather
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
        photosWorker: PhotosWorking,
        weatherRepository: WeatherRepositoryProtocol,
        locationService: CoreLocationServiceProtocol
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
            model.photosState = await model.photosState
                .authorizationStatus(photosWorker.requestAuthorizationStatus())
            
        case .viewWillAppear:
            break
            
        case .updateWeather:
            if let location = model.locationState.location {
                await requestWeather(at: location)
                await reqeustWeather(at: location, dateRange: model.dateRange)
                model.weather = weatherRepository[location]
                model.lastYearWeathers = weatherRepository[location]
                let assets = await photosWorker.fetchPhotosAssets(
                    startDate: model.dateRange.start,
                    endDate: model.dateRange.end
                )
                model.photosState = model.photosState
                    .assets(assets)
            } else {
                logger.log("updatedCurrentLocation 실패, locationState.location: \(String(describing:  model.locationState.location)) ")
            }
        }
        
        return model
    }
    
    private func requestWeather(at location: CLLocation) async {
        do {
            try await weatherRepository.requestWeather(for: location)
        } catch {
            logger.error("날씨 요청 에러: \(error)")
            let parameters = [
                "message": error.localizedDescription,
                "file": #file,
                "function": #function
            ]
            Analytics.logEvent("Weather_Request_Error", parameters: parameters)
        }
    }
    
    private func reqeustWeather(at location: CLLocation, dateRange: (start: Date, end: Date)) async {
        do {
            try await weatherRepository.requestWeathr(
                for: location,
                startDate: dateRange.start,
                endDate: dateRange.end
            )
        } catch {
            logger.error("Apple Weather 과거 날씨 요청 실패\n다음 에러: \(error)")
            let parameters = [
                "message": error.localizedDescription,
                "file": #file,
                "function": #function
            ]
            Analytics.logEvent("Interacting Error", parameters: parameters)
        }
    }
}
