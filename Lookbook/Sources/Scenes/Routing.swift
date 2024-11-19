import UIKit
import Swinject

protocol Routing:  AnyObject {
    var destination: ViewController? { get set }
    var container: Container { get }
    
    func show(viewController name: String)
    func push(viewController name: String)
    func dismiss()
    func pop()
}

extension Routing {
  
    func show(viewController name: String) {
        guard let destination else { fatalError("Destination is nil") }
        let nextViewController = container.resolve(ViewController.self, name: name)!
        destination.present(nextViewController, animated: true)
    }
    
    func push(viewController name: String) {
        guard let destination else { fatalError("Destination is nil") }
        let nextViewController = container.resolve(ViewController.self, name: name)!
        destination.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func dismiss() {
        destination?.dismiss(animated: true)
    }
    
    func pop() {
        destination?.navigationController?.popViewController(animated: true)
    }
}
