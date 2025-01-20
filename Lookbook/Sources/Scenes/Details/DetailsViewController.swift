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
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .gradientEffect(
            colors: [.black, .clear],
            locations: nil,
            frame: CGRect(
                x: 0,
                y: 0,
                width: navigationBar.frame.width,
                height: navigationBar.frame.height + 60
            ),
            startPoint: CGPoint(
                x: 0.5,
                y: 0
            ),
            endPoint: CGPoint(
                x: 0.5,
                y: 1
            )
        )
        
        appearance.shadowColor = nil
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
}
