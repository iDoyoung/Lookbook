import UIKit
import Combine
import SwiftUI
import CoreLocation

final class TodayViewController: ViewController {
    
    // Components
    private var model = TodayModel() {
        didSet {
            rootView?.model = model
        }
    }
    
    private var interactor: TodayInteractable = TodayInteractor()
    
    // UI
    private var rootView: TodayRootView?
    private var cancellableBag = Set<AnyCancellable>()
    private var hostingController: UIHostingController<TodayRootView>?
    
    // MARK: - Method
    private func buildHostingController() {
        rootView = TodayRootView(
            model: model
        )
        
        if let rootView {
            hostingController = UIHostingController(rootView: rootView)
        } else {
            fatalError()
        }
    }
   
    static func buildToday(
        locationService: CoreLocationService,
        weatherRepository: WeatherRepositoryProtocol,
        photosWorker: PhotosWorker
    ) -> TodayViewController {
        let viewController = TodayViewController()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            model = await interactor.execute(
                action: .viewWillAppear,
                with: model
            )
        }
        observeDestinationTracking()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
    }
    
    func presentSetting() {
        let destination = SettingViewController()
        let navigationController = UINavigationController(rootViewController: destination)
        
        self.present(navigationController, animated: true)
    }
    
    // Create Notification To Oberserve Setting Of Fahrenheit
    private func fahrenheitNotificationCenter() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.model.unitTemperature = UserSetting.isFahrenheit ? .fahrenheit: .celsius
            }
            .store(in: &cancellableBag)
    }
    
    @discardableResult
    private func observeDestinationTracking() -> TodayModel.Destination? {
        withObservationTracking {
           rootView?.model.destination
        } onChange: {
            Task {
                switch await self.model.destination {
                case .setting:
                    await self.presentSetting()
                case .none:
                    break
                }
            }
        }
    }
}
