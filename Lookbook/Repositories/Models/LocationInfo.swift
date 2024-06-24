import Foundation
import CoreLocation

struct LocationInfo {
    var name: String?
    var location: CLLocation?
    
    var latitude: Double? {
        location?.coordinate.latitude
    }
    
    var longitude: Double? {
        location?.coordinate.longitude
    }
}
