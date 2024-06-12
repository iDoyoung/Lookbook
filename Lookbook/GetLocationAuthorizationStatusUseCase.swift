import Foundation
import os
import CoreLocation
import Combine

protocol GetLocationAuthorizationStatusUseCaseProtocol {
    func execute(completion: @escaping (LocationAuthorizationStatus) -> Void)
}

final class GetLocationAuthorizationStatusUseCase: GetLocationAuthorizationStatusUseCaseProtocol {
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (LocationAuthorizationStatus) -> Void) {
        repository.authorizationStatus.sink { status in
            switch status {
            case .notDetermined, .restricted, .denied: completion(.unauthorized)
            case .authorizedAlways, .authorizedWhenInUse, .authorized: completion(.authorized)
            default: break
            }
        }
        .store(in: &cancellableBag)
        
        logger.log("Execute get location authorization")
    }
    
    private var repository: LocationRepositoryProtocol
    private var cancellableBag = Set<AnyCancellable>()
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.LocationUseCase", category: "Use Case")
}
