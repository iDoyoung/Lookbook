import UIKit
import Combine
import SwiftUI

final class TodayViewController: ViewController {
    
    // MARK: - Properties
    
    var requestWeatherUseCase: RequestWeatherUseCaseProtocol?
    var photosUseCase: PhotosUseCaseProtocol?
    var locationUseCase: LocationUseCaseProtocol?
    
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
        locationUseCase?.executeRequestAuthorization()
    }
    
    static func buildToday(
        requestWeatherUseCase: RequestWeatherUseCaseProtocol,
        photosUseCase: PhotosUseCaseProtocol,
        locationUseCase: LocationUseCaseProtocol) -> TodayViewController {
            let viewController = TodayViewController()
            viewController.requestWeatherUseCase = requestWeatherUseCase
            viewController.locationUseCase = locationUseCase
            viewController.photosUseCase = photosUseCase
            
            return viewController
        }
    
//    private func requestCurrentLocation() {
//        switch locationManager?.authorizationStatus {
//        case .notDetermined:
//            locationManager?.requestAuthorization()
//        case .restricted, .denied:
//            break
//        case .authorizedAlways, .authorizedWhenInUse:
//            break
//        case nil:
//            defaultLogger.debug("Location manager is nil")
//        @unknown default:
//            break
//        }
//    }
       
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHostingController()
        // - setup hosting controller
        
        guard let hostingController else { fatalError() }
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        guard let rootView,
              let photosUseCase else { return }
        
        Task {
            rootView.model.photosAuthorizationStatus = await photosUseCase.execute()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
