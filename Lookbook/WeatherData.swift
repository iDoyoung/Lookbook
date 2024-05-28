import WeatherKit
import CoreLocation
import os

class WeatherData {
    
    let service = WeatherService()
    let logger = Logger(subsystem: "io.doyoung.Lookbook.WeatherData", category: "Weather")
    
    func getWeathers(with location: CLLocation, startDate: Date, endDate: Date) async throws {
//        let weathers = try await service.weather(for: location, including: .daily(startDate: startDate, endDate: endDate))
        let weather = try await service.weather(for: location)
//        let temp = weather.currentWeather.temperature
        print("===============================")
        weather.hourlyForecast.forEach { weather in
            print(weather)
            print("++++++")
        }
//        weather.hourlyForecast.forEach { weather in
//            print(weather)
//            print("++++++")
//        }
       
//        print(weather.)
//            print($0.temperature)
//            print($0.condition)
//            print($0.symbolName)
//            print($0.uvIndex)
//            print($0.date)
//        }
//        logger.log("\(weather.currentWeather.condition)")
        
//        logger.log("Weathers of \(startDate) to \(endDate): \(weathers.forecast.map { $0.highTemperature})")
    }
}
