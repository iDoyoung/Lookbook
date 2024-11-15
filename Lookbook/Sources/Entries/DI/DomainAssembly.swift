import Foundation
import Swinject

final class DomainAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(TodayInteractable.self) { resolver in
            TodayInteractor(
                photosWorker: resolver.resolve(PhotosWorking.self)!,
                weatherRepository: resolver.resolve(WeatherRepositoryProtocol.self)!,
                locationService: resolver.resolve(CoreLocationServiceProtocol.self)!
            )
        }
    }
}
