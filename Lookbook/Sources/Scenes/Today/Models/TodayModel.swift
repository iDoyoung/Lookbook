import Foundation
import Photos
import UIKit
import Combine

@Observable
final class TodayModel {
    
    private var cancellablesBag = Set<AnyCancellable>()
    
    var unitTemperature: UnitTemperature = .celsius
    var photosAuthorizationStatus: PhotosAuthStatus? = nil
    var locationAuthorizationStatus: LocationAuthorizationStatus? = nil
    var location: LocationInfo? = nil
    var weather: CurrentlyWeather? = nil
    var photosData: [Data] = []
    var lastYearWeathers: [DailyWeather]? = nil
    var photosAssets: [PHAsset] = []
    
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
        return photosAssets.map { asset in
            let filteredWeather = lastYearWeathers?.filter({ weather in
                guard let assetCreateDate = asset.creationDate else { return false }
                return Date.isEqual(date1: weather.date, date2: assetCreateDate)
            }).first
            
            return OutfitPhoto(
                asset: asset,
                highTemp: filteredWeather?.maximumTemperature.converted(to: unitTemperature).rounded ?? "",
                lowTemp: filteredWeather?.minimumTemperature.converted(to: unitTemperature).rounded ?? ""
            )
        }
    }
    
    init() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.unitTemperature = UserSetting.isFahrenheit ? .fahrenheit: .celsius
            }
            .store(in: &cancellablesBag)
    }
}
