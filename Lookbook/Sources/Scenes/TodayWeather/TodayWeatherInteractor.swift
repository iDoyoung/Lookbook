import Foundation

enum TodayWeatherViewAction {
    case viewDidLoad
}

protocol TodayWeatherInteractable {
    func execute(action: TodayWeatherViewAction, with model: TodayWeatherModel) async -> TodayWeatherModel
}

final class TodayWeatherInteractor: TodayWeatherInteractable {
    
    // Service
    var weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
   
    func execute(action: TodayWeatherViewAction, with model: TodayWeatherModel) async -> TodayWeatherModel {
        switch action {
        case .viewDidLoad:
            if let location = model.locationState.location {
                model.weather = weatherRepository[location]
            }
        }
        
        return model
    }
}
