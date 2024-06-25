import UIKit
import Combine
import SwiftUI
import CoreLocation

final class TodayViewController: ViewController {
    
    // MARK: - Properties
    
    // Repository
    var locationRepository: LocationRepositoryProtocol?
    var weatherRepository: WeatherRepositoryProtocol?
    
    var photosUseCase: PhotosUseCaseProtocol?
    
    // UI
    
    private var model = TodayModel()
    private var rootView: TodayRootView?
    private var cancellableBag = Set<AnyCancellable>()
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
        locationRepository?.requestAuthorization()
//        requestLocationAuthorizationUseCase?.execute()
    }
    
    static func buildToday(
        locationRepository: LocationRepositoryProtocol,
        weatherRepository: WeatherRepositoryProtocol,
        photosUseCase: PhotosUseCaseProtocol) -> TodayViewController {
            let viewController = TodayViewController()
            viewController.locationRepository = locationRepository
            viewController.weatherRepository = weatherRepository
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
        
        guard let rootView,
              let photosUseCase,
              let locationRepository else {
            defaultLogger.debug("Some compoenent(s) is(are) nil")
            return
        }
       
        // Interactor
        locationRepository.currentLocation.sink { location in
            self.rootView?.model.location = location
            if let location = location?.location {
                Task.detached {  @MainActor in
                    try await self.weatherRepository?.requestWeather(for: location)
                    let currentWeather: WeatherData? = self.weatherRepository?[location]
                   
                    rootView.model.weather = currentWeather
                }
            }
        }
        .store(in: &cancellableBag)
        
        locationRepository.authorizationStatus.sink { status in
            switch status {
            case .notDetermined, .restricted, .denied:
                self.rootView?.model.locationAuthorizationStatus = .unauthorized
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                self.rootView?.model.locationAuthorizationStatus = .authorized
            default:
                self.rootView?.model.locationAuthorizationStatus = .unauthorized
            }
        }
        .store(in: &cancellableBag)
        
        Task {
            rootView.model.photosAuthorizationStatus = await photosUseCase.execute()
        }
    }
}
