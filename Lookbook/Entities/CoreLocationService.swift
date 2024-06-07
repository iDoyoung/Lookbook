import Foundation
import CoreLocation
import os

protocol CoreLocationServiceProtocol {
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    func requestAuthorization()
    func requestCurrentLocation()
}

final class CoreLocationService: NSObject, CoreLocationServiceProtocol {
    
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
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
   
    func requestCurrentLocation() {
        logger.log("Expression requestLocation()")
        manager.startUpdatingLocation()
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    
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
