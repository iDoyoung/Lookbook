import Foundation

struct WeatherOfLocation: Codable {
    var location: String? = nil
    var date: Date? = nil
    
    var currentTemperature: String? = nil
    var maximumTemperature: String? = nil
    var minimumTemperature: String? = nil
    var feelTemperature: String? = nil
    
    var iconName: String? = nil
    var condition: String? = nil
    var forecast: [WeatherOfLocation] = []
}
