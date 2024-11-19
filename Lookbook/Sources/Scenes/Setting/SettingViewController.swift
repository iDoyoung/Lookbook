import UIKit
import SwiftUI

final class SettingViewController: ViewController {
    
    // MARK: - Private Properties
    private var rootView: SettingRootView!
    private var hostingController: UIHostingController<SettingRootView>!
    
    private var router: Routing
    
    private lazy var closeButton: UIBarButtonItem = {
        let image = UIImage(systemName: "xmark")
        return UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(closeSetting)
        )
    }()
    
    private func buildHostingController() {
        rootView = SettingRootView()
        hostingController = UIHostingController(rootView: rootView)
    }
    
    //MARK: - View Controller Life Cycle
    
    init(router: Routing) {
        self.router = router
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        router.pop()
    }
}
