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
    
    private var interactor: TodayInteractable
    private var router: Routing
    
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
    
    // Life Cycle
    init(model: TodayModel = TodayModel(), interactor: TodayInteractable, router: Routing) {
        self.model = model
        self.interactor = interactor
        self.router = router
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHostingController()
        
        // - setup hosting controller
        guard let hostingController else { fatalError() }
        
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        fahrenheitNotificationCenter()
        observeDestinationTracking()
        observeCurrentLocationTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            model = await interactor.execute(
                action: .viewWillAppear,
                with: model
            )
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Create Notification To Oberserve Setting Of Fahrenheit
    private func fahrenheitNotificationCenter() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.model.unitTemperature = UserSetting.isFahrenheit ? .fahrenheit: .celsius
            }
            .store(in: &cancellableBag)
    }
    
    private func presentSetting() {
        router.push(viewController: SettingViewController.name)
    }
    
    @discardableResult
    private func observeDestinationTracking() -> TodayModel.Destination? {
        withObservationTracking {
            model.destination
        } onChange: { [weak self] in
            Task {  @MainActor in
                switch self?.model.destination {
                case .setting:
                    self?.presentSetting()
                case .none:
                    break
                }
            }
        }
    }
    
    @discardableResult
    private func observeCurrentLocationTracking() -> LocationServiceState? {
        withObservationTracking {
            rootView?.model.locationState
        } onChange: { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                self.model = await self.interactor.execute(action: .updatedCurrentLocation, with: self.model)
            }
        }
    }
}
