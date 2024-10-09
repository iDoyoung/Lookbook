import Foundation
import CoreLocation
import Combine
import os

enum LocationServiceUsecase {
    case requestLocation
    case requestAuthorization
}

protocol CoreLocationServiceProtocol {
    
    associatedtype State: LocationServiceState
    
    func execute(_ useCase: LocationServiceUsecase, with state: State) async -> State
}

final class CoreLocationService: NSObject, CoreLocationServiceProtocol {
    
    
    typealias State = LocationServiceState
    private(set) var state: State
    private var currentLocationHandler: ((CLLocation) -> Void)?
    private var authorizationHandler: ((CLAuthorizationStatus) -> Void)?
    
    static func create(with state: LocationServiceState) -> Self {
        let coreLocationService = Self(state: state)
        return coreLocationService
    }
    
    // Private
    private var locationFetcher: LocationFetcher
    
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.LocationManager",
        category: "Location Manager"
    )
    
    init(state: State, locationFetcher: LocationFetcher = CLLocationManager()) {
        self.state = state
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
    }
    
    //MARK: - Public
    
    func execute(_ useCase: LocationServiceUsecase, with state: State) async -> State {
        let state = state
        switch useCase {
        case .requestLocation:
            state.location = await requestLocation()
        case .requestAuthorization:
            break
        }
        return state
    }
    
    func requestAuthorization() {
        guard locationFetcher.authorizationStatus != .authorizedWhenInUse else {
            logger.log("Current location status is authorized")
            return
        }
        logger.log("Request when in use authorization")
        locationFetcher.requestWhenInUseAuthorization()
    }
    
    private func requestLocation() async -> CLLocation {
        return await withCheckedContinuation { continuation in
            currentLocationHandler = { location in
                continuation.resume(returning: location)
            }
            locationFetcher.startUpdatingLocation()
        }
    }
}

extension CoreLocationService: LocationFetcherDelegate {
    
    func locationManagerDidChangeAuthorization(_ fetcher: LocationFetcher) {
        state.authorizationStatus = fetcher.authorizationStatus
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didUpdate locations: [CLLocation]) {
        if let location = locations.last {
            logger.log("Read location by Core Location: \(location)")
            currentLocationHandler?(location)
            locationFetcher.stopUpdatingLocation()
        }
    }
    
    func locationFetcher(_ fetcher: LocationFetcher, didFailWithError error: Error) {
        state.error = error
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        logger.log("Change Location Authorization")
        self.locationFetcher.locationFetcherDelegate?.locationManagerDidChangeAuthorization(manager)
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
