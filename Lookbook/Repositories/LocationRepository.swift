import Foundation
import Combine
import CoreLocation

protocol LocationRepositoryProtocol {
    
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
    
    func requestAuthorization()
}

final class LocationRepository: LocationRepositoryProtocol {
    
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never>
    
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
        self.authorizationStatus = CurrentValueSubject(service.authorizationStatusSubject.value)
        
        service.authorizationStatusSubject.sink { [weak self] status in
            self?.authorizationStatus.send(status)
        }
        .store(in: &cancellableBag)
    }
    
    // Private
    private var service: CoreLocationServiceProtocol
    private var cancellableBag = Set<AnyCancellable>()
}
