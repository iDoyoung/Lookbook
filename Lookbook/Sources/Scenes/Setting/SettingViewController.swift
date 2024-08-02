import UIKit
import SwiftUI

final class SettingViewController: ViewController {
    
    // MARK: - Private Properties
    private var rootView: SettingRootView!
    private var hostingController: UIHostingController<SettingRootView>!
    
    private lazy var closeButton: UIBarButtonItem = {
        let image = UIImage(systemName: "xmark")
        return UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(closeSetting)
        )
    }()
    
    //MARK: - View Controller Life Cycle
    private func buildHostingController() {
        rootView = SettingRootView()
        hostingController = UIHostingController(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .label
        buildHostingController()
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        title = "설정"
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc
    private func closeSetting() {
        dismiss(animated: true)
    }
}
