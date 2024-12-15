import CoreLocation
import os

@Observable
final class LocationServiceState {
    
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.LocationServiceState", category: "State")
    var location: CLLocation?
    var authorizationStatus: CLAuthorizationStatus?
    var error: Error?
    
    func name(_ location: CLLocation) async -> String? {
        await location.name
    }
    
    func currentLocation(_ location: CLLocation) async -> Self {
        self.location = location
       
        return self
    }
    
    func authorizationStatus(_ status: CLAuthorizationStatus) -> LocationServiceState {
        self.authorizationStatus = status
        logger.log("Authorization status: \(String(describing: status))")
        
        return self
    }
}
