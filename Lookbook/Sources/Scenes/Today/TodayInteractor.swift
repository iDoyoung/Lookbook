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
            model.photosState = await model.photosState
                .authorizationStatus(photosWorker.requestAuthorizationStatus())
                .assets(
                    photosWorker.fetchPhotosAssets(
                        startDate: model.dateRange.start,
                        endDate: model.dateRange.end
                    )
                )
            
        case .viewWillAppear:
            break
            
        case .requestWeather:
            if let location = model.locationState.location {
                do {
                    try await weatherRepository.requestWeather(for: location)
                    await model.locationName = locationService.state.name(location)
                    model.weather = weatherRepository[location]
                    
                    if model.photosState.authorizationStatus == .authorized || model.photosState.authorizationStatus == .limited {
                        await requestLastMonthWeather(
                            location: location,
                            startDate: model.dateRange.start,
                            endDate: model.dateRange.end
                        )
                        guard let currentMaxTemperature = model.maximumTemperature,
                              let currentMinTemperature = model.minimumTemperature else {
                            return model
                        }
                        model.lastYearWeathers = weatherRepository[location]?
                            .sorted { (lhs, rhs) -> Bool in
                                let similarity1 = calculateSimilarityTemperature(
                                    current: (max: currentMaxTemperature, min: currentMinTemperature),
                                    past: (max: lhs.maximumTemperature.value, min: rhs.minimumTemperature.value))
                                let similarity2 = calculateSimilarityTemperature(
                                    current: (max: currentMaxTemperature, min: currentMinTemperature),
                                    past: (max: rhs.maximumTemperature.value, min: rhs.minimumTemperature.value))
                                return similarity1 > similarity2
                            }
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
    
    private func requestLastMonthWeather(location: CLLocation, startDate: Date, endDate: Date) async {
        let calendar = Calendar.current
        var start = startDate
       
        while start < endDate {
            
            let afterTenDays = calendar.date(byAdding: .day, value: 10, to: start) ?? start
            _ = try? await weatherRepository.requestWeathr(
                for: location,
                startDate: start,
                endDate: afterTenDays
            )
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            start = calendar.date(byAdding: .day, value: 11, to: start) ?? start
        }
    }
    
    private func calculateSimilarityTemperature(current: (max: Double, min: Double), past: (max: Double, min: Double)) -> Double {
        let highDifference = abs(current.max - past.max)
        let lowDifference = abs(current.min - past.min)
        
        return highDifference + lowDifference
    }
}

