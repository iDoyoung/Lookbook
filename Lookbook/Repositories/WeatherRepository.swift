import Foundation
import os
import WeatherKit
import CoreLocation

protocol WeatherRepositoryProtocol {
    @discardableResult
    func requestWeather(for location: (latitude: Double, longitude: Double)) async throws -> Weather
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    var currentWeathers = [CLLocation: WeatherData]()
    var dailyWeathers = [CLLocation: [WeatherData]]()
    var houlyWeathers = [CLLocation: [WeatherData]]()
    
    @discardableResult
    func requestWeather(for location: (latitude: Double, longitude: Double)) async throws -> Weather {
        logger.log("Execute Request Weather")
        let coreLocation = CLLocation(
            latitude: location.latitude,
            longitude: location.longitude)
        
        let weather = try await service.weather(for: coreLocation)
        
        currentWeathers[coreLocation] = WeatherData(for: weather.currentWeather)
        dailyWeathers[coreLocation] = weather.dailyForecast.map { WeatherData(for: $0) }
        houlyWeathers[coreLocation] = weather.hourlyForecast.map {  WeatherData(for: $0) }
        
        return weather
    }
    
    subscript(location: CLLocation) -> WeatherData? {
        currentWeathers[location]
    }
    
    private let service = WeatherService.shared
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.WeatherRepository", category: "Repository")
}
