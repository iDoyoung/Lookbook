import Foundation
import UIKit
import Photos

@Observable
final class DetailsModel {
    var phAsset: PHAsset? {
        didSet {
            Task {
                imageData = await phAsset?.data()
                location = await phAsset?.location?.name
            }
        }
    }
    
    var weather: DailyWeather?
    
    var imageData: Data?
    
    var creationDateText: String {
        if let creationDate = phAsset?.creationDate {
            return creationDate.longStyleWithTime
        } else {
            return ""
        }
    }
    var location: String?
    
    var maximumTemperature: String {
        weather?.maximumTemperature.rounded ?? ""
    }
    
    var minimumTemperature: String {
        weather?.minimumTemperature.rounded ?? ""
    }
    
    init(asset: PHAsset?, weather: DailyWeather? = nil) {
        phAsset = asset
        self.weather = weather
    }
}
