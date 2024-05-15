import UIKit
import os

class ViewController: UIViewController {
    
    let defaultLogger = Logger()

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLogger.log("\(type(of: self)) View Did Load")
    }
    
    deinit {
        defaultLogger.log("Deallocating instance of '\(type(of: self))'")
    }
}

