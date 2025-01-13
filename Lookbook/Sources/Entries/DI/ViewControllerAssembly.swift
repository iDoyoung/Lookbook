import Foundation
import Swinject

final class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        //MARK: - Today(main)
        container.register(ViewController.self, name: TodayViewController.name) { resolver in
            let locationService = resolver.resolve(CoreLocationServiceProtocol.self)!
            return TodayViewController(
                model: TodayModel(locationState: locationService.state),
                interactor: resolver.resolve(TodayInteractable.self)!,
                router: resolver.resolve(TodayRouter.self, name: "Today")!
            )
        }
        
        container.register(TodayRouter.self, name: "Today") { _ in TodayRouter(container: container) }
            .initCompleted { resolver, router in
                let viewController = resolver.resolve(ViewController.self, name: TodayViewController.name)!
                router.destination = viewController
            }
        
        container.register(DetailsViewController.self) { resolver in
            return DetailsViewController(
                model: DetailsModel()
            )
        }
        
        container.register(Routing.self, name: "Detail") { _ in DetailsRouter(container: container) }
            .initCompleted { resolver, router in
                let viewController = resolver.resolve(ViewController.self, name: DetailsViewController.name)!
                router.destination = viewController
            }
        
        container.register(ViewController.self, name: SettingViewController.name) { resolver in
            SettingViewController(router: resolver.resolve(Routing.self, name: "Setting")!)
        }
        
        container.register(Routing.self, name: "Setting") { _ in SettingRouter(container: container) }
            .initCompleted { resolver, router in
                let viewController = resolver.resolve(ViewController.self, name: SettingViewController.name)!
                router.destination = viewController
            }
    }
}
