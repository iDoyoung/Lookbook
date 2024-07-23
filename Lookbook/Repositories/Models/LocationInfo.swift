import Foundation
import CoreLocation

struct LocationInfo: Equatable {
    var name: String?
    var location: CLLocation?
    
    var latitude: Double? {
        location?.coordinate.latitude
    }
    
    var longitude: Double? {
        location?.coordinate.longitude
    }
    
    static func == (lhs: LocationInfo, rhs: LocationInfo) -> Bool {
        return lhs.location == rhs.location
    }
}
