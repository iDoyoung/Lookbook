import Foundation
import os
import WeatherKit
import CoreLocation

protocol WeatherRepositoryProtocol {
    subscript(location: CLLocation) -> WeatherData? { get }
    
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> Weather
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private var weathers = [CLLocation: WeatherData]()
    
    /// WeatherKit 프레임 워크 사용하여 날씨 요청
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> Weather {
        logger.log("Execute Request Weather")
        let weather = try await service.weather(for: location)
        
        self.weathers[location] = WeatherData(for: weather)
        
        return weather
    }
    
    subscript(location: CLLocation) -> WeatherData? {
        weathers[location]
    }
    
    private let service = WeatherService.shared
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.WeatherRepository", category: "Repository")
}
