import Foundation
import WeatherKit

struct DailyWeather {
    
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
