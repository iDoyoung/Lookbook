import Foundation
import Combine
import CoreLocation

protocol LocationRepositoryProtocol {
    var currentLocation: CurrentValueSubject<LocationInfo?, Never> { get }
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
    
    func requestAuthorization()
}

final class LocationRepository: LocationRepositoryProtocol {
    
    var currentLocation: CurrentValueSubject<LocationInfo?, Never>
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never>
    
    func requestAuthorization() {
        service.requestAuthorization()
    }
    
    init(service: CoreLocationServiceProtocol) {
        self.service = service
        self.currentLocation = CurrentValueSubject(nil)
        self.authorizationStatus = CurrentValueSubject(service.authorizationStatusSubject.value)
        
        service.locationSubject.sink { location in
            Task { [weak self] in
                let locationName = await location?.name
                
                let locationInfo = LocationInfo(
                    name: locationName,
                    latitude: location?.coordinate.latitude,
                    longitude: location?.coordinate.longitude
                )
                self?.currentLocation.send(locationInfo)
            }
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

extension CLLocation {
    
    var name: String? {
        get async {
            let placemarks = try? await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks?.first?.locality
        }
    }
}
