import CoreLocation
import os

@Observable
final class LocationServiceState {
    
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.LocationServiceState", category: "State")
    var location: CLLocation?
    var authorizationStatus: CLAuthorizationStatus?
    var error: Error?
    var locationName: String?
    
    func currentLocation(_ location: CLLocation) async -> Self {
        self.location = location
        self.locationName = await location.name
        logger.log("Current location: \(self.locationName ?? "Unknown")")
        
        return self
    }
    
    func authorizationStatus(_ status: CLAuthorizationStatus) -> LocationServiceState {
        self.authorizationStatus = status
        logger.log("Authorization status: \(String(describing: status))")
        
        return self
    }
}
