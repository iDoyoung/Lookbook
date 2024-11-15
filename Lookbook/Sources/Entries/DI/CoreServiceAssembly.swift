import Foundation
import Swinject

final class CoreServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(WeatherRepositoryProtocol.self) { resolver in
            WeatherRepository()
        }
        container.register(PhotosWorking.self) { resolver in
            PhotosWorker()
        }
        container.register(CoreLocationServiceProtocol.self) { resolver in
            CoreLocationService()
        }
    }
}
