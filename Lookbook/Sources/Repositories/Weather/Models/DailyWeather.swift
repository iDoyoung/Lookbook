import Foundation
import WeatherKit

struct DailyWeather {
    
    var date: Date
    
    ///The high temperature  forecast from 7AM - 7PM on this day.
    var dayTimeMaximumTemperature: Measurement<UnitTemperature>?
    
    ///The low  temperature  forecast from 7AM - 7PM on this day.
    var dayTimeMinimumTemperature: Measurement<UnitTemperature>?
    
    var condition: String?
    var symbolName: String?
    
    var maximumTemperature: Measurement<UnitTemperature>
    var minimumTemperature: Measurement<UnitTemperature>
    
    var precipitationChance: Int?
    
    init(
        date: Date,
        dayTimeMaximumTemperature: Measurement<UnitTemperature>? = nil,
        dayTimeMinimumTemperature: Measurement<UnitTemperature>? = nil,
        condition: String? = nil,
        symbolName: String? = nil,
        maximumTemperature: Measurement<UnitTemperature>,
        minimumTemperature: Measurement<UnitTemperature>,
        precipitationChance: Int? = nil
    ) {
        self.date = date
        self.dayTimeMaximumTemperature = dayTimeMaximumTemperature
        self.dayTimeMinimumTemperature = dayTimeMinimumTemperature
        self.condition = condition
        self.symbolName = symbolName
        self.maximumTemperature = maximumTemperature
        self.minimumTemperature = minimumTemperature
        self.precipitationChance = precipitationChance
    }
    
    init(for dayWeather: DayWeather) {
        date = dayWeather.date
        dayTimeMaximumTemperature = dayWeather.daytimeForecast.highTemperature
        dayTimeMinimumTemperature = dayWeather.daytimeForecast.lowTemperature
        
        maximumTemperature = dayWeather.highTemperature
        minimumTemperature = dayWeather.lowTemperature
        
        condition = dayWeather.condition.accessibilityDescription
        
        symbolName = dayWeather.symbolName
        precipitationChance = Int(dayWeather.precipitationChance * 100)
    }
}
