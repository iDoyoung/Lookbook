import UIKit
import SwiftUI
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
        defaultLogger.log("🪟 \(type(of: self)), call \(#function)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultLogger.log("🪟 \(type(of: self)), call \(#function)")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        defaultLogger.log("🪟 \(type(of: self)), call \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultLogger.log("🪟 \(type(of: self)), call \(#function)")
    }
      
    deinit {
        defaultLogger.log("⚫️ Deallocating instance of '\(type(of: self))'")
    }
}

extension ViewController {
    func hostingController(rootView: some View) {
        let hostingController = UIHostingController(rootView: rootView)
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        hostingController.view.backgroundColor = .clear
        view.addSubview(hostingController.view)
    }
}
