import Foundation
import CoreLocation

@testable import Lookbook

class WeatherRepositorySpy: WeatherRepositoryProtocol {
    var calledRequestWeather = false
    var calledRequestWeathrForDateRange = false
    
    subscript(location: CLLocation) -> Lookbook.CurrentlyWeather? {
        return CurrentlyWeather.stub()
    }
    
    subscript(location: CLLocation) -> [Lookbook.DailyWeather]? {
        return DailyWeather.stubs()
    }
    
    func requestWeather(for location: CLLocation) async throws -> Lookbook.CurrentlyWeather? {
        calledRequestWeather.toggle()
        
        return CurrentlyWeather.stub()
    }
    
    func requestWeathr(for location: CLLocation, startDate: Date, endDate: Date) async throws -> [Lookbook.DailyWeather] {
        calledRequestWeathrForDateRange.toggle()
        
        return DailyWeather.stubs()
    }
}
