import Foundation
import WeatherKit

struct CurrentlyWeather {
    
    var current: Current?
    var hourlyForecast: [HourlyWeather]?
    var dailyForecast: [DailyWeather]?
    
    struct Current {
        var date: Date
        
        var temperature: Measurement<UnitTemperature>
        var feelTemperature: Measurement<UnitTemperature>
        
        var condition: String
        var symbolName: String
    }
    
    init() { }
    
    init(for weather: Weather) {
        let currentWeather = weather.currentWeather
        current = Current(
            date: currentWeather.date,
            temperature: currentWeather.temperature,
            feelTemperature: currentWeather.apparentTemperature,
            condition: currentWeather.condition.accessibilityDescription,
            symbolName: currentWeather.symbolName)
        dailyForecast = weather.dailyForecast.map { DailyWeather(for: $0)}
        hourlyForecast = Array(weather.hourlyForecast
            .filter { $0.date > weather.currentWeather.date }
            .map { HourlyWeather(for: $0) }
            .prefix(24))
    }
}
