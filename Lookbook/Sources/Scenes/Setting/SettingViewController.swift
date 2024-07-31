import UIKit
import SwiftUI

final class SettingViewController: ViewController {
    
    // MARK: - Private Properties
    private var rootView: SettingRootView!
    private var hostingController: UIHostingController<SettingRootView>!
    
    //MARK: - View Controller Life Cycle
    
    private func buildHostingController() {
        rootView = SettingRootView(temperatureUnit: .celsius)
        hostingController = UIHostingController(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildHostingController()
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
    }
}
