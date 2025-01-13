import UIKit
import SwiftUI

final class DetailsViewController: ViewController {

    //  MARK: - Components
    var model: DetailsModel
    
    private var rootView: DetailsRootView?
    private var hostingController: UIHostingController<DetailsRootView>?
    
    private func buildHostingController() {
        rootView = DetailsRootView(
            model: model
        )
        
        if let rootView {
            hostingController = UIHostingController(rootView: rootView)
        } else {
            fatalError()
        }
    }
    
    // MARK: - Life Cycle
    init(
        model: DetailsModel
    ) {
        self.model = model
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHostingController()
        guard let hostingController else { fatalError() }
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
    }
}
