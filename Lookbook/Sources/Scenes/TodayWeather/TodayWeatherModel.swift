import Foundation
import CoreLocation
import Photos

@Observable
final class TodayWeatherModel {
    
    var weather: CurrentlyWeather?
     
    var locationName: String?
    var locationAuthorizationStatus: CLAuthorizationStatus?
    var photosAuthorizationStatus: PHAuthorizationStatus?
    var unitTemperature: UnitTemperature = .celsius
    
    var symbolName: String? {
        weather?.current?.symbolName
    }
    
    var weatherCondition: String {
        weather?.current?.condition ?? ""
    }
    
    var currentTemperature: String {
        weather?.current?.temperature.converted(to: unitTemperature).rounded ?? "=="
    }
    
    var maximumTemperatureText: String {
        "최고:" + (weather?.dailyForecast?[0].maximumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var minimumTemperatureText: String {
        "최저:" + (weather?.dailyForecast?[0].minimumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var feelTemperature: String {
        "체감 온도:" + (weather?.current?.feelTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    /// 금일 시간별 날씨 정보
    var todayForcast: [TodayForecast]? {
        return weather?.hourlyForecast?.compactMap({ weather in
            TodayForecast(hourlyWeather: weather, unit: unitTemperature)
        })
    }
    
    var date: String {
        if let weatherDate = weather?.current?.date {
            "\(weatherDate)"
        } else {
            ""
        }
    }
    
    init(
        weather: CurrentlyWeather?,
        locationName: String?,
        locationAuthorizationStatus: CLAuthorizationStatus?,
        photosAuthorizationStatus: PHAuthorizationStatus?) {
            self.weather = weather
            self.locationName = locationName
            self.locationAuthorizationStatus = locationAuthorizationStatus
            self.photosAuthorizationStatus = photosAuthorizationStatus
        }
}
