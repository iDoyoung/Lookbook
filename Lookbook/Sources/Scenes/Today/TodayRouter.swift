import UIKit
import Swinject

final class TodayRouter: Routing {
    
    weak var destination: ViewController?
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
}
