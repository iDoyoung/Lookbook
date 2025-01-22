import UIKit
import Swinject

protocol Routing:  AnyObject {
    var destination: ViewController? { get set }
    
    func dismiss()
    func pop()
}

extension Routing {
  
    func dismiss() {
        destination?.dismiss(animated: true)
    }
    
    func pop() {
        destination?.navigationController?.popViewController(animated: true)
    }
}
