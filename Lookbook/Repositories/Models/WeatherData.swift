import Foundation
import WeatherKit

struct WeatherData {
    
    var date: Date?
    
    var temperature: String?
    var feelTemperature: String?
    
    var maximumTemperature: String?
    var minimumTemperature: String?
    
    var iconName: String?
    var condition: String?
    
    init() { }
    
    init(for currentWeather: CurrentWeather) {
        date = currentWeather.date
        temperature = currentWeather.temperature.rounded
        feelTemperature = currentWeather.apparentTemperature.rounded
        iconName = currentWeather.symbolName
        condition = currentWeather.condition.accessibilityDescription
    }
    
    init(for dayWeather: DayWeather) {
        date = dayWeather.date
        maximumTemperature = dayWeather.highTemperature.rounded
        minimumTemperature = dayWeather.lowTemperature.rounded
        iconName = dayWeather.symbolName
        condition = dayWeather.condition.accessibilityDescription
    }
    
    init(for hourWeather: HourWeather) {
        date = hourWeather.date
        temperature = hourWeather.temperature.rounded
        feelTemperature = hourWeather.apparentTemperature.rounded
        iconName = hourWeather.symbolName
        condition = hourWeather.condition.accessibilityDescription
    }
}

extension WeatherData: Codable {    }

private extension Measurement<UnitTemperature> {
    
    var rounded: String {
        "\(self.value.formatted(.number.precision(.fractionLength(0))))\(self.unit)"
    }
}
