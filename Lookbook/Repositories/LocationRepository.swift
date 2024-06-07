import Foundation
import Combine
import CoreLocation

protocol LocationRepositoryProtocol {
    
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestAuthorization()
}

final class LocationRepository: LocationRepositoryProtocol {
    
    @Published var currentLocation: CLLocation?
    
    var authorizationStatus: CLAuthorizationStatus {
        service.getAuthorizationStatus()
    }
    
    func requestAuthorization() {
        service.requestAuthorization()
    }
    
    func startUpdatingLocation() {
        service.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        service.stopUpdatingLocation()
    }
    
    init(service: CoreLocationServiceProtocol) {
        self.service = service
    }
    
    // Private
    private var service: CoreLocationServiceProtocol
}
