import CoreLocation

@Observable
final class LocationServiceState {
    var location: CLLocation?
    var authorizationStatus: CLAuthorizationStatus?
}
