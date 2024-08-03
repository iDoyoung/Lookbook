import WeatherKit
import Foundation

struct HourlyWeather {
    var date: Date
    
    var temperature: Measurement<UnitTemperature>
    var feelTemperature: Measurement<UnitTemperature>
    
    var condition: String
    var symbolName: String
    var precipitationChance: Int
    
    init(
        date: Date,
        temperature: Measurement<UnitTemperature>,
        feelTemperature: Measurement<UnitTemperature>,
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
        
        temperature = hourWeather.temperature
        feelTemperature = hourWeather.apparentTemperature
        
        condition = hourWeather.condition.accessibilityDescription
        
        symbolName = hourWeather.symbolName
        precipitationChance = Int(hourWeather.precipitationChance * 100)
    }
}
