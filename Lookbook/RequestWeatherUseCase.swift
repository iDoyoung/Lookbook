import Foundation
import CoreLocation
import WeatherKit
import os

protocol RequestWeatherUseCaseProtocol {
    func execute(with location: CLLocation) async throws -> TheDayWeather
}

struct RequestWeatherUseCase {
    
    private var repository: WeatherRepositoryProtocol
    
    /// Request Current Weahter
    func execute(with location: CLLocation) async throws -> TheDayWeather {
        let weather = try await repository.requestWeather(with: location)
        let current = weather.currentWeather
        let dayilayForecast = weather.dailyForecast
        
        let hourlyForecast = weather.hourlyForecast.map {
            TheDayWeather(
                temp: $0.temperature.rounded,
                condition: $0.condition.description,
                iconName: $0.symbolName)
        }
      
        return TheDayWeather(
            temp: current.temperature.rounded,
            maxTemp: dayilayForecast.first?.highTemperature.rounded,
            minTemp: dayilayForecast.first?.lowTemperature.rounded,
            feelTemp: current.apparentTemperature.rounded,
            condition: current.condition.description,
            iconName: current.symbolName,
            forecast: hourlyForecast)
    }
}

private extension Measurement<UnitTemperature> {
    
    var rounded: String {
        "\(self.value.formatted(.number.precision(.fractionLength(0))))\(self.unit)"
    }
}
