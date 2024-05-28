import UIKit
import Combine
import SwiftUI

final class TodayViewController: ViewController {

    // MARK: - Properties
    
    var requestWeatherUseCase: RequestWeatherUseCaseProtocol?
    var locationManager: LocationManager?
    
    // UI
    
    private let rootView = TodayRootView()
    private lazy var hostingController = UIHostingController(rootView: rootView)
    
    // MARK: - Method
    
    static func buildToday(requestWeatherUseCase: RequestWeatherUseCaseProtocol, locationManager: LocationManager) -> TodayViewController {
        let viewController = TodayViewController()
        viewController.requestWeatherUseCase = requestWeatherUseCase
        viewController.locationManager = locationManager
        
        return viewController
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - setup hosting controller
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        let _ = locationManager?.$location.sink { [weak self] location in
            guard let useCase = self?.requestWeatherUseCase else {
                self?.defaultLogger.debug("Request Weather Use Case is nil")
                return
            }
            if let location {
                Task {
                    let weather = try await useCase.execute(with: location)
                    self?.rootView.weather = weather
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager?.requestCurrentLocation()
    }
}
