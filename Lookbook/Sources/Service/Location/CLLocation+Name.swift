import CoreLocation

extension CLLocation {
    var name: String? {
        get async {
            let placemarks = try? await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks?.first?.locality
        }
    }
}

