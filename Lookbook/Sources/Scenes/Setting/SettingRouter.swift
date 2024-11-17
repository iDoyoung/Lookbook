import UIKit
import Swinject

final class SettingRouter: Routing {
    
    weak var destination: ViewController?
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
}
