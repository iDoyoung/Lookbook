import Foundation
import Swinject

final class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ViewController.self, name: TodayViewController.name) { resolver in
            TodayViewController(
                interactor: resolver.resolve(TodayInteractable.self)!,
                router: resolver.resolve(Routing.self, name: "Today")!
            )
        }
        
        container.register(Routing.self, name: "Today") { _ in TodayRouter(container: container) }
            .initCompleted { resolver, router in
                let viewController = resolver.resolve(ViewController.self, name: TodayViewController.name)!
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
