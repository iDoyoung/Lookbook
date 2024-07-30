import Foundation
import os
import WeatherKit
import CoreLocation

protocol WeatherRepositoryProtocol {
    subscript(location: CLLocation) -> CurrentlyWeather? { get }
    subscript(location: CLLocation) -> [DailyWeather]? { get }
    
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> Weather
    
    @discardableResult
    func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [DailyWeather]
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private var currentWeathers = [CLLocation: CurrentlyWeather]()
    private var weathersOfDate = [CLLocation: [DailyWeather]]()
    
    /// WeatherKit 프레임 워크 사용하여 날씨 요청
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> Weather {
        logger.log("Execute Request Weather")
        do {
            let weather = try await service.weather(for: location)
            self.currentWeathers[location] = CurrentlyWeather(for: weather)
            
            return weather
        } catch {
            logger.error("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    @discardableResult
    func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [DailyWeather] {
        do {
            let forecasts = try await service.weather(
                for: location,
                including: .daily(
                    startDate: startDate,
                    endDate: startDate < endDate ? endDate: Calendar.current.date(
                        byAdding: .day,
                        value: 10,
                        to: startDate
                    )!
                )
            )
            logger.log("Fetched Weathers: \(String(describing: forecasts))")
            let weathers = forecasts
                .map { weather in
                    DailyWeather(for: weather)
                }
            
            self.weathersOfDate[location] = weathers
            return weathers
        } catch {
            logger.error("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    subscript(location: CLLocation) -> CurrentlyWeather? {
        currentWeathers[location]
    }
    
    subscript(location: CLLocation) -> [DailyWeather]? {
        weathersOfDate[location]
    }
    
    private let service = WeatherService.shared
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.WeatherRepository", category: "Repository")
}
