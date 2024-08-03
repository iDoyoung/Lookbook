import Foundation
import WeatherKit

struct DailyWeather {
    
    var date: Date
    
    var condition: String
    var symbolName: String
    
    var maximumTemperature: Measurement<UnitTemperature>
    var minimumTemperature: Measurement<UnitTemperature>
    
    var precipitationChance: Int
    
    init(
        date: Date,
        condition: String,
        symbolName: String,
        maximumTemperature: Measurement<UnitTemperature>,
        minimumTemperature: Measurement<UnitTemperature>,
        precipitationChance: Int
    ) {
        self.date = date
        self.condition = condition
        self.symbolName = symbolName
        self.maximumTemperature = maximumTemperature
        self.minimumTemperature = minimumTemperature
        self.precipitationChance = precipitationChance
    }
    
    init(for dayWeather: DayWeather) {
        date = dayWeather.date
        
        maximumTemperature = dayWeather.highTemperature
        minimumTemperature = dayWeather.lowTemperature
        
        condition = dayWeather.condition.accessibilityDescription
        
        symbolName = dayWeather.symbolName
        precipitationChance = Int(dayWeather.precipitationChance * 100)
    }
}
