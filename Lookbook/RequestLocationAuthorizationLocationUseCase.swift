import Foundation
import os
import CoreLocation

protocol RequestLocationAuthorizationUseCaseProtocol {
    func execute()
}

final class RequestLocationAuthorizationLocationUseCase: RequestLocationAuthorizationUseCaseProtocol {
    
    // Public
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
   
    func execute() {
        logger.log("Execute request location authorization")
        repository.requestAuthorization()
    }
    
    // Private
    
    private var repository: LocationRepositoryProtocol
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.LocationUseCase", category: "Use Case")
}
