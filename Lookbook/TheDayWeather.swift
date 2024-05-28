import Foundation

@Observable
class TheDayWeather {
    
    var date: Date?
    var temp: String?
    var maxTemp: String?
    var minTemp: String?
    var feelTemp: String?
    var condition: String?
    var iconName: String?
    var forecast: [TheDayWeather]
    
    init(date: Date? = nil,
        temp: String? = nil,
         maxTemp: String? = nil,
         minTemp: String? = nil,
         feelTemp: String? = nil,
         condition: String? = nil,
         iconName: String? = nil,
         forecast: [TheDayWeather] = []) {
        self.date = date
        self.temp = temp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.feelTemp = feelTemp
        self.condition = condition
        self.iconName = iconName
        self.forecast = forecast
    }
}
