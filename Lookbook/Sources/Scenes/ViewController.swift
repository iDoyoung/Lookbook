import UIKit
import os

class ViewController: UIViewController {
    
    let defaultLogger = Logger(subsystem: "", category: "View Controller")

    static var name: String {
        "\(self))"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        defaultLogger.log("🟢 Allocating instance of '\(type(of: self))'")
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLogger.log("🪟 \(type(of: self)), View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultLogger.log("🪟 \(type(of: self)), View will appear")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        defaultLogger.log("🪟 \(type(of: self)), View is appearing")
    }
      
    deinit {
        defaultLogger.log("⚫️ Deallocating instance of '\(type(of: self))'")
    }
}
