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
   
    init(asset: PHAsset) {
        self.asset = asset
    }
}
