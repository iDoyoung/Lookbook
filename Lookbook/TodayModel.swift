import Foundation
import Photos
import UIKit

@Observable
class TodayModel {
    var photosAuthorizationStatus: PhotosAuthStatus? = nil
    var locationAuthorizationStatus: LocationAuthorizationStatus = .unauthorized
    var location: LocationInfo? = nil
    var weather: CurrentlyWeather? = nil
    var photosData: [Data] = []
    var lastYearWeathers: [DailyWeather]? = nil
    var photosAssets: [PHAsset] = []
    
    var outfitPhotos: [OutfitPhoto] {
        return photosAssets.map { asset in
            let filteredWeather = lastYearWeathers?.filter({ weather in
                guard let assetCreateDate = asset.creationDate else { return false }
                return Date.isEqual(date1: weather.date, date2: assetCreateDate)
            }).first
            
            return OutfitPhoto(
                asset: asset,
                highTemp: filteredWeather?.maximumTemperature ?? "",
                lowTemp: filteredWeather?.minimumTemperature ?? ""
            )
        }
    }
}
