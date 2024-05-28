import Foundation
import WeatherKit
import CoreLocation

protocol WeatherRepositoryProtocol {
    func requestWeather(with location: CLLocation) async throws -> Weather
}

class WeatherRepository: WeatherRepositoryProtocol {
    
    private let service = WeatherService.shared
    var currentWeathers: [CLLocation: Weather] = [:]
    
    func requestWeather(with location: CLLocation) async throws -> Weather {
        if let weather = currentWeathers[location] {
            return weather
        } else {
            let weather = try await service.weather(for: location)
            currentWeathers[location] = weather
            return weather
        }
    }
}
