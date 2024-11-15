import Foundation
import Swinject

final class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(TodayViewController.self) { resolver in
            TodayViewController(
                interactor: resolver.resolve(TodayInteractable.self)!,
                router: TodayRouter()
            )
        }
        container.register(SettingViewController.self) { resolver in
            SettingViewController()
        }
    }
}
