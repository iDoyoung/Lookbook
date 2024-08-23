import Foundation
import Photos
import CoreLocation

@Observable
final class OutfitPhoto {
    
    var asset: PHAsset
    
    var id: String  {
        asset.localIdentifier
    }
    
    var creationDate: String? {
        asset.creationDate?.longStyle
    }
    
    var location: CLLocation? {
        asset.location
    }
   
    var highTemp: String
    var lowTemp: String
    
    init(asset: PHAsset, highTemp: String, lowTemp: String) {
        self.asset = asset
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
}
