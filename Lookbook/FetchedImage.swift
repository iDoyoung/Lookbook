import UIKit
import CoreLocation

@Observable
class FetchedImage {
    let image: UIImage
    let createdDate: Date? 
    let location: CLLocation?
    
    init(image: UIImage, createdDate: Date? = nil, location: CLLocation? = nil) {
        self.image = image
        self.createdDate = createdDate
        self.location = location
    }
}

