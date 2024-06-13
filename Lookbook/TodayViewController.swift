import UIKit
import Combine
import SwiftUI

final class TodayViewController: ViewController {
    
    // MARK: - Properties
    
    var requestWeatherUseCase: RequestWeatherUseCaseProtocol?
    var photosUseCase: PhotosUseCaseProtocol?
    var getLocationAuthorizationLocationUseCase: GetLocationAuthorizationStatusUseCaseProtocol?
    var requestLocationAuthorizationUseCase: RequestLocationAuthorizationUseCaseProtocol?
    
    // UI
    
    private var rootView: TodayRootView?
    private var hostingController: UIHostingController<TodayRootView>?
    
    // MARK: - Method
    private func buildHostingController() {
        rootView = TodayRootView(
            model: TodayModel(),
            tapLocationWaringLabel: { [weak self] in
            self?.requestLocationAuthorization()
        })
        if let rootView {
            hostingController = UIHostingController(rootView: rootView)
        } else {
            fatalError()
        }
    }
    
    func requestLocationAuthorization() {
        defaultLogger.log("Try to execute request authorization")
        requestLocationAuthorizationUseCase?.execute()
    }
    
    static func buildToday(
        requestWeatherUseCase: RequestWeatherUseCaseProtocol,
        photosUseCase: PhotosUseCaseProtocol,
        getLocationAuthorizationLocationUseCase: GetLocationAuthorizationStatusUseCaseProtocol,
        requestLocationAuthorizationUseCase: RequestLocationAuthorizationUseCaseProtocol) -> TodayViewController {
            let viewController = TodayViewController()
            viewController.requestWeatherUseCase = requestWeatherUseCase
            viewController.getLocationAuthorizationLocationUseCase = getLocationAuthorizationLocationUseCase
            viewController.requestLocationAuthorizationUseCase = requestLocationAuthorizationUseCase
            viewController.photosUseCase = photosUseCase
            
            return viewController
        }
      
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHostingController()
        // - setup hosting controller
        
        guard let hostingController else { fatalError() }
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        // Interactor
        guard let rootView,
              let photosUseCase,
              let requestLocationAuthorizationUseCase,
              let getLocationAuthorizationLocationUseCase else { return }
        
        Task {
            rootView.model.photosAuthorizationStatus = await photosUseCase.execute()
        }
        
        getLocationAuthorizationLocationUseCase.execute { [weak self] status in
            self?.rootView?.model.locationAuthorizationStatus = status
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
