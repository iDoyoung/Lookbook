import Foundation
import CoreLocation
import Combine
import os

protocol CoreLocationServiceProtocol {
   
    var locationSubject: CurrentValueSubject<CLLocation?, Never> { get }
    var authorizationStatusSubject: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
  
    
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    func requestAuthorization()
    func requestCurrentLocation()
}

final class CoreLocationService: NSObject, CoreLocationServiceProtocol {
    
    var locationSubject: CurrentValueSubject<CLLocation?, Never>
    var authorizationStatusSubject: CurrentValueSubject<CLAuthorizationStatus, Never>
  
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
        guard manager.authorizationStatus != .authorizedWhenInUse else {
            logger.log("Current location status is authorized")
            return
        }
        logger.log("Request when in use authorization")
        manager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        logger.log("Expression requestLocation()")
        manager.startUpdatingLocation()
    }
    
    override init() {
        manager = CLLocationManager()
        locationSubject = CurrentValueSubject(nil)
        authorizationStatusSubject = CurrentValueSubject(manager.authorizationStatus)
        super.init()
        manager.delegate = self
    }
    
    // Private
    private var manager: CLLocationManager
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.LocationManager", category: "Location Manager")
}

extension CoreLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        logger.log("Change Location Authorization")
        authorizationStatusSubject.send(manager.authorizationStatus)
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            logger.log("Read location by Core Location: \(location)")
            locationSubject.send(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Error: \(error.localizedDescription)")
    }
}
