import Foundation
import WeatherKit

struct WeatherData {
    
    var current: Current?
    var hourlyForecast: [Hourly]?
    var dailyForecast: [Daily]?
    
    struct Current {
        var date: Date
        
        var temperature: String
        var feelTemperature: String
        
        var condition: String
        var symbolName: String
    }
    
    struct Hourly {
        var date: Date
        
        var temperature: String
        var feelTemperature: String
        
        var condition: String
        var symbolName: String
        var precipitationChance: Int
        
        init(date: Date, temperature: String, feelTemperature: String, condition: String, symbolName: String, precipitationChance: Int) {
            self.date = date
            self.temperature = temperature
            self.feelTemperature = feelTemperature
            self.condition = condition
            self.symbolName = symbolName
            self.precipitationChance = precipitationChance
        }
       
        init(for hourWeather: HourWeather) {
            date = hourWeather.date
            
            temperature = hourWeather.temperature.rounded
            feelTemperature = hourWeather.apparentTemperature.rounded
            
            condition = hourWeather.condition.accessibilityDescription
            
            symbolName = hourWeather.symbolName
            precipitationChance = Int(hourWeather.precipitationChance * 100)
        }
    }
    
    struct Daily {
        var date: Date
        var condition: String
        var symbolName: String

        var maximumTemperature: String
        var minimumTemperature: String
        
        var precipitationChance: Int
        
        init(date: Date, condition: String, symbolName: String, maximumTemperature: String, minimumTemperature: String, precipitationChance: Int) {
            self.date = date
            self.condition = condition
            self.symbolName = symbolName
            self.maximumTemperature = maximumTemperature
            self.minimumTemperature = minimumTemperature
            self.precipitationChance = precipitationChance
        }
        
        init(for dayWeather: DayWeather) {
            date = dayWeather.date
            
            maximumTemperature = dayWeather.highTemperature.rounded
            minimumTemperature = dayWeather.lowTemperature.rounded
            
            condition = dayWeather.condition.accessibilityDescription
            
            symbolName = dayWeather.symbolName
            precipitationChance = Int(dayWeather.precipitationChance * 100)
        }
    }
    
    init() { }
    
    init(for weather: Weather) {
        let currentWeather = weather.currentWeather
        current = Current(
            date: currentWeather.date,
            temperature: currentWeather.temperature.rounded,
            feelTemperature: currentWeather.apparentTemperature.rounded,
            condition: currentWeather.condition.accessibilityDescription,
            symbolName: currentWeather.symbolName)
        dailyForecast = weather.dailyForecast.map { Daily(for: $0)}
        hourlyForecast = Array(weather.hourlyForecast
            .filter { $0.date > weather.currentWeather.date }
            .map { Hourly(for: $0)}
            .prefix(24))
    }
}

private extension Measurement<UnitTemperature> {
    
    var rounded: String {
        "\(self.value.formatted(.number.precision(.fractionLength(0))))" + "º"
    }
}
