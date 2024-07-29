import UIKit
import Combine
import SwiftUI
import CoreLocation

final class TodayViewController: ViewController {
    
    // MARK: - Properties
    
    var photosWorker: PhotosWorker?
    // Repository
    var locationRepository: LocationRepositoryProtocol?
    var weatherRepository: WeatherRepositoryProtocol?
    
    // UI
    
    private var model = TodayModel()
    private var rootView: TodayRootView?
    private var cancellableBag = Set<AnyCancellable>()
    private var hostingController: UIHostingController<TodayRootView>?
    
    // MARK: - Method
    private func buildHostingController() {
        rootView = TodayRootView(
            model: TodayModel()
       )
        if let rootView {
            hostingController = UIHostingController(rootView: rootView)
        } else {
            fatalError()
        }
    }
   
    func requestLocationAuthorization() {
        defaultLogger.log("Try to execute request authorization")
        locationRepository?.requestAuthorization()
    }
    
    static func buildToday(
        locationRepository: LocationRepositoryProtocol,
        weatherRepository: WeatherRepositoryProtocol,
        photosWorker: PhotosWorker
    ) -> TodayViewController {
        let viewController = TodayViewController()
        viewController.locationRepository = locationRepository
        viewController.weatherRepository = weatherRepository
        viewController.photosWorker = photosWorker
        
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
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        guard let rootView,
              let locationRepository else {
            defaultLogger.debug("Some component(s) is(are) nil")
            return
        }
        
        // Interactor
        locationRepository.currentLocation.sink { location in
            self.rootView?.model.location = location
            if let location = location?.location {
                Task.detached {  @MainActor in
                    try await self.weatherRepository?.requestWeather(for: location)
                    await self.requestLastYearWeathers(location: location)
                    let currentWeather: CurrentlyWeather? = self.weatherRepository?[location]
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
            switch try? await photosWorker?.authorizationStatus() {
            case .notDetermined:
                break
            case .restricted, .denied:
                rootView.model.photosAuthorizationStatus = .restrictedOrDenied
            case .authorized:
                rootView.model.photosAuthorizationStatus = .all
                rootView.model.photosAssets = (try? await photosWorker?.fetchPhotosAssets()) ?? []
            case .limited:
                rootView.model.photosAuthorizationStatus = .limited
            case .none:
                defaultLogger.debug("Photos 권한 nil")
            @unknown default:
                defaultLogger.debug("")
            }
        }
    }
  
    func requestLastYearWeathers(location: CLLocation) async {
        let calendar = Calendar.current
        let today = Date()
        guard let lastYear = calendar.date(byAdding: .year, value: -1, to: today),
              let lastYearAndTenDayAgo = calendar.date(byAdding: .day, value: -10, to: lastYear) else {
            return
        }
        try! await weatherRepository?.requestWeathr(for: location, startDate: lastYearAndTenDayAgo, endDate: lastYear)
        rootView?.model.lastYearWeathers = self.weatherRepository?[location]
    }
}
