import Foundation
import CoreLocation
import os

protocol LocationManagerProtocol {
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestAuthorization()
    func requestCurrentLocation()
}

final class LocationManager: NSObject, LocationManagerProtocol {
    
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.LocationManager", category: "Location Manager")
    private var manager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
   
    func requestCurrentLocation() {
        logger.log("Expression requestLocation()")
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            logger.log("Read location by Core Location: \(location)")
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Error: \(error.localizedDescription)")
    }
}
