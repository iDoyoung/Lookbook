import Foundation
import CoreLocation
import Combine
import os

enum CoreLocationServiceUseCase { case requestLocation, requestAuthorization }

protocol CoreLocationServiceProtocol {
    func requestLocation() async -> CLLocation
    func requestAuthorization() async -> CLAuthorizationStatus
}

final class CoreLocationService: NSObject, CoreLocationServiceProtocol {
    
    private var continuation: CheckedContinuation<CLLocation, Never>?
    
    private var didChangeAuthorizationHandler: ((CLAuthorizationStatus) -> Void)?
   
    // Private
    private var locationFetcher: LocationFetcher
    
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.CoreLocationService",
        category: "Location Manager"
    )
    
    init(locationFetcher: LocationFetcher = CLLocationManager()) {
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
    }
   
    func requestLocation() async -> CLLocation {
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            locationFetcher.requestLocation()
        }
    }
    
    func requestAuthorization() async -> CLAuthorizationStatus {
        
        guard locationFetcher.authorizationStatus == .notDetermined else {
            return locationFetcher.authorizationStatus
        }
        
        logger.log("Location authorization is not determined. Requesting authorization...")
        return await withCheckedContinuation { continuation in
            didChangeAuthorizationHandler = { authorizationStatus in
                continuation.resume(returning: authorizationStatus)
            }
            locationFetcher.requestWhenInUseAuthorization()
        }
    }
}

extension CoreLocationService: LocationFetcherDelegate {
    
    func locationManagerDidChangeAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        didChangeAuthorizationHandler?(authorizationStatus)
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didUpdate locations: [CLLocation]) {
        if let location = locations.last {
            logger.log("Read location by Core Location: \(location)")
            continuation?.resume(returning: location)
            continuation = nil
            fetcher.stopUpdatingLocation()
        }
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didFailWithError error: Error) {
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        logger.log("Change Location Authorization")
        self.locationFetcher.locationFetcherDelegate?.locationManagerDidChangeAuthorization(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logger.log("Updating Location")
        
        self.locationFetcher.locationFetcherDelegate?.locationFetcher(
            manager,
            didUpdate: locations
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Error: \(error.localizedDescription)")
        self.locationFetcher.locationFetcherDelegate?.locationFetcher(manager, didFailWithError: error)
    }
}
