import Foundation
import Combine
import CoreLocation
import os

protocol GetCurrentLocationUseCaseProtocol {
    func execute(completion: @escaping (String) -> Void)
}

final class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
   
    //FIXME: - Closure에 블럭 내부에 async/await을 사용하는 방법이 옳은가?
    func execute(completion: @escaping (String) -> Void) {
        repository.currentLocation.sink { location in
            Task {
                guard let locationName = try await location?.name else {
                    self.logger.debug("Location is nil")
                    return
                }
                completion(locationName)
            }
        }
        .store(in: &cancellableBag)
    }
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    private var repository: LocationRepositoryProtocol
    private var cancellableBag = Set<AnyCancellable>()
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.GetCurrentLocationUseCase)", category: "Use Case")
}

extension CLLocation {
    var name: String? {
        get async throws {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks.first?.locality
        }
    }
}
