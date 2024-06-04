import UIKit
import Combine
import SwiftUI

final class TodayViewController: ViewController {

    // MARK: - Properties
    
    var requestWeatherUseCase: RequestWeatherUseCaseProtocol?
    var photosUseCase: PhotosUseCaseProtocol?
    var locationManager: LocationManagerProtocol?
    
    // UI
    
    private let rootView = TodayRootView()
    
    private lazy var hostingController = UIHostingController(rootView: rootView)
    
    // MARK: - Method
    
    static func buildToday(
        requestWeatherUseCase: RequestWeatherUseCaseProtocol,
        photosUseCase: PhotosUseCaseProtocol,
        locationManager: LocationManager) -> TodayViewController {
            let viewController = TodayViewController()
            viewController.requestWeatherUseCase = requestWeatherUseCase
            viewController.locationManager = locationManager
            viewController.photosUseCase = photosUseCase
            
            return viewController
        }
    
    private func requestCurrentLocation() {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case nil:
            defaultLogger.debug("Location manager is nil")
        @unknown default:
            break
        }
    }
       
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - setup hosting controller
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case nil:
            defaultLogger.debug("Location manager is nil")
        @unknown default:
            break
        }
        
        // Photos Auth
        Task {
            let photosAuthStatus = await photosUseCase?.execute()
            debugPrint(photosAuthStatus)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        locationManager?.requestCurrentLocation()
    }
}
