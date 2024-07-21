import WeatherKit
import Foundation

struct HourlyWeather {
    var date: Date
    
    var temperature: String
    var feelTemperature: String
    
    var condition: String
    var symbolName: String
    var precipitationChance: Int
    
    init(
        date: Date,
        temperature: String,
        feelTemperature: String,
        condition: String,
        symbolName: String,
        precipitationChance: Int
    ) {
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
