import Foundation
import CoreLocation
import Combine
import os

enum CoreLocationServiceUseCase { case requestLocation, requestAuthorization }

protocol CoreLocationServiceProtocol {
    var state: LocationServiceState { get }
    func requestLocation()
    func requestAuthorization()
}

final class CoreLocationService: NSObject, CoreLocationServiceProtocol {
    
    private(set) var state: LocationServiceState
    
    private var locationContinuation: CheckedContinuation<CLLocation, Never>?
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var didChangeAuthorizationHandler: ((CLAuthorizationStatus) -> Void)?
   
    // Private
    private var locationFetcher: LocationFetcher
    
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.CoreLocationService",
        category: "🗺️ Location Manager"
    )
    
    init(
        state: LocationServiceState,
        locationFetcher: LocationFetcher = CLLocationManager()
    ) {
        self.state = state
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
    }
   
    func requestLocation() {
        locationFetcher.startUpdatingLocation()
    }
    
    /// Request Core Location Authorization when authorizationStatus is not determinded call requestWhenInUseAuthorization()
    func requestAuthorization() {
        state.authorizationStatus = locationFetcher.authorizationStatus
        if state.authorizationStatus == .notDetermined {
            locationFetcher.requestWhenInUseAuthorization()
        }
    }
}

extension CoreLocationService: LocationFetcherDelegate {
    
    func locationManagerDidChangeAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        logger.log("🗺️ Change Location Authorization: \(authorizationStatus.rawValue)")
        state.authorizationStatus = authorizationStatus
        
        switch state.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationFetcher.startUpdatingLocation()
        case .notDetermined, .denied, .restricted:
            logger.log("🗺️ Set up default location")
            state.location = .seoul
        default:
            break
        }
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didUpdate locations: [CLLocation]) {
        if let location = locations.last {
            fetcher.stopUpdatingLocation()
            
            if let previousLocation = state.location {
                let distance = previousLocation.distance(from: location)
                if distance > 50 {
                    logger.log("🗺️ Distance exceeded 50m: \(distance)m. Updating location.")
                    state.location = location
                } else {
                    logger.log("🗺️ Distance is less than or equal to 50m: \(distance)m. Location not updated.")
                }
            } else {
                logger.log("🗺️ No previous location. Setting initial location.")
                state.location = location
            }
        }
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didFailWithError error: Error) {
        logger.error("🗺️ Failed to read location by Core Location: \(error)")
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        logger.log("🗺️ Change Location Authorization")
        self.locationFetcher.locationFetcherDelegate?.locationManagerDidChangeAuthorization(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logger.log("🗺️ Updating Location")
        
        self.locationFetcher.locationFetcherDelegate?.locationFetcher(
            manager,
            didUpdate: locations
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("🗺️ Error: \(error.localizedDescription)")
        self.locationFetcher.locationFetcherDelegate?.locationFetcher(manager, didFailWithError: error)
    }
}
