import Foundation
import Photos
import CoreLocation

struct OutfitPhoto {
    
    private var asset: PHAsset
    
    var id: String  {
        asset.localIdentifier
    }
    
    var creationDate: Date? {
        asset.creationDate
    }
    
    var location: CLLocation? {
        asset.location
    }
    
    var imageData: Data {
        get async {
            await asset.data()
        }
    }
}
