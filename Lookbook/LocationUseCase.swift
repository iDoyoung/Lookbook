import Foundation
import CoreLocation

protocol LocationUseCaseProtocol {
    func executeRequestAuthorization()
}

final class LocationUseCase: LocationUseCaseProtocol {
    
    // Public
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeRequestAuthorization() {
        repository.requestAuthorization()
    }
    
    // Private
    
    private var repository: LocationRepositoryProtocol
}
