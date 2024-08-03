import Foundation

@Observable
class TodayForecast {
    var hourlyWeather: HourlyWeather
    var unit: UnitTemperature
    
    var date: String {
        hourlyWeather.date.hour
    }
    
    var symbolName: String {
        hourlyWeather.symbolName
    }
    
    var temperature: String {
        hourlyWeather.temperature.converted(to: unit).rounded
    }
    
    init(hourlyWeather: HourlyWeather, unit: UnitTemperature) {
        self.hourlyWeather = hourlyWeather
        self.unit = unit
    }
}
