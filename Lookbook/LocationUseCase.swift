import Foundation
import os
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
        logger.log("Execute request location authorization")
        repository.requestAuthorization()
    }
    
    // Private
    
    private var repository: LocationRepositoryProtocol
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.LocationUseCase", category: "Use Case")
}
