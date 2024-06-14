import Foundation
import Combine
import CoreLocation

protocol LocationRepositoryProtocol {
    var currentLocation: CurrentValueSubject<CLLocation?, Never> { get }
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
    
    func requestAuthorization()
}

final class LocationRepository: LocationRepositoryProtocol {
    
    var currentLocation: CurrentValueSubject<CLLocation?, Never>
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never>
    
    func requestAuthorization() {
        service.requestAuthorization()
    }
    
    init(service: CoreLocationServiceProtocol) {
        self.service = service
        self.currentLocation = CurrentValueSubject(service.locationSubject.value)
        self.authorizationStatus = CurrentValueSubject(service.authorizationStatusSubject.value)
        
        service.locationSubject.sink { [weak self] location in
            self?.currentLocation.send(location)
        }
        .store(in: &cancellableBag)
        
        service.authorizationStatusSubject.sink { [weak self] status in
            self?.authorizationStatus.send(status)
        }
        .store(in: &cancellableBag)
    }
    
    // Private
    private var service: CoreLocationServiceProtocol
    private var cancellableBag = Set<AnyCancellable>()
}
