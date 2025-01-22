import Foundation
import os
import WeatherKit
import CoreLocation

protocol WeatherRepositoryProtocol {
    subscript(location: CLLocation) -> CurrentlyWeather? { get }
    subscript(location: CLLocation) -> [DailyWeather]? { get }
    
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> CurrentlyWeather?
    
    @discardableResult
    func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [DailyWeather]
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private var currentWeathers = [CLLocation: CurrentlyWeather]()
    private var weathersOfDate = [CLLocation: [DailyWeather]]()
    
    
    /// WeatherKit 프레임 워크 사용하여 날씨 요청
    @discardableResult
    func requestWeather(for location: CLLocation) async throws -> CurrentlyWeather? {
        logger.log("Execute Request Weather")
        do {
            let weather = try await service.weather(for: location)
            self.currentWeathers[location] = CurrentlyWeather(for: weather)
            
            return self.currentWeathers[location]
        } catch {
            logger.error("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    @discardableResult
    func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [DailyWeather] {
        do {
            let pastThirtyDaysSummary = try await service
                .dailySummary(
                    for: location,
                    forDaysIn: DateInterval(start: startDate, end: endDate),
                    including: .temperature
                )
                .map {
                    DailyWeather(
                        date: $0.date,
                        maximumTemperature: $0.highTemperature,
                        minimumTemperature: $0.lowTemperature
                    )
                }
            
            logger.log("Fetched Weathers: \(String(describing: pastThirtyDaysSummary))")
            
            if weathersOfDate[location] != nil {
                weathersOfDate[location]! += pastThirtyDaysSummary
            } else {
                weathersOfDate[location] = pastThirtyDaysSummary
            }
                
            return pastThirtyDaysSummary
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
