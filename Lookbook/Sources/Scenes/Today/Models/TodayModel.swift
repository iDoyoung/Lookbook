import Foundation
import Photos
import UIKit
import CoreLocation

@Observable
final class TodayModel {
    
    enum Destination { case setting }
    
    // States
    var destination: Destination? = nil
    var hiddingWeatherTag: Bool = false
    var weatherTagScale: CGFloat = 1
    
    var locationState: LocationServiceState
    var photosState: PhotosState
    
    var locationName: String? = nil
    var presentSetting: Bool = false
    var unitTemperature: UnitTemperature = .celsius
    
    var dateRange: (start: Date, end: Date) {
        let now = Date()
        let oneYearAndFiveDaysAgo = now.oneYearAndFiveDaysAgo
        return (oneYearAndFiveDaysAgo, oneYearAndFiveDaysAgo.tenDaysAfter())
    }
   
    // MARK: - Weather 모델 리펙토링하기
    var weather: CurrentlyWeather? = nil
    var lastYearWeathers: [DailyWeather]? = nil
    
    init(
        locationState: LocationServiceState,
        photosState: PhotosState = .init()
    ) {
        self.locationState = locationState
        self.photosState = photosState
    }
    
    var currentTemperature: String {
        weather?.current?.temperature.converted(to: unitTemperature).rounded ?? "--"
    }
    
    var symbolName: String? {
        weather?.current?.symbolName
    }
    
    var weatherCondition: String {
        weather?.current?.condition ?? ""
    }
    
    var maximumTemperature: String {
        "최고:" + (weather?.dailyForecast?[0].maximumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var minimumTemperature: String {
        "최저:" + (weather?.dailyForecast?[0].minimumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var feelTemperature: String {
        "체감 온도:" + (weather?.current?.feelTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var todayForcast: [TodayForecast]? {
        return weather?.hourlyForecast?.compactMap({ weather in
            TodayForecast(hourlyWeather: weather, unit: unitTemperature)
        })
    }
    
    var outfitPhotos: [OutfitPhoto] {
        return photosState.assets?.compactMap { asset in
            let filteredWeather = lastYearWeathers?
                .filter { weather in
                    guard let assetCreateDate = asset.creationDate else { return false }
                    return Date.isEqual(lhs: weather.date, rhs: assetCreateDate)
                }
                .first
            
            return OutfitPhoto(
                asset: asset,
                highTemp: filteredWeather?.maximumTemperature.converted(to: unitTemperature).rounded ?? "",
                lowTemp: filteredWeather?.minimumTemperature.converted(to: unitTemperature).rounded ?? ""
            )
        } ?? []
    }
}
