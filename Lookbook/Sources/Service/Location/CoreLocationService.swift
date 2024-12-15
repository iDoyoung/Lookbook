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
    
    private(set) var state = LocationServiceState()
    
    private var locationContinuation: CheckedContinuation<CLLocation, Never>?
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var didChangeAuthorizationHandler: ((CLAuthorizationStatus) -> Void)?
   
    // Private
    private var locationFetcher: LocationFetcher
    
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.CoreLocationService",
        category: "🗺️ Location Manager"
    )
    
    init(locationFetcher: LocationFetcher = CLLocationManager()) {
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
    }
   
    func requestLocation() {
        locationFetcher.requestLocation()
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
        state.authorizationStatus = authorizationStatus
        logger.log("🗺️ Change Location Authorization: \(authorizationStatus.rawValue)")
        if state.authorizationStatus == .authorizedWhenInUse {
            locationFetcher.requestLocation()
        }
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didUpdate locations: [CLLocation]) {
        if let location = locations.last {
            logger.log("🗺️ Read location by Core Location: \(location)")
            state.location = location
            fetcher.stopUpdatingLocation()
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
