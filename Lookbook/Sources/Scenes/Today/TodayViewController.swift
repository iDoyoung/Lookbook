import UIKit
import Combine
import SwiftUI
import CoreLocation
import Observation

final class TodayViewController: ViewController {
    
    // Components
    private var model: TodayModel
    
    private var interactor: TodayInteractable
    private var router: TodayRouter
    
    // UI
    private var rootView: TodayRootView?
    private var cancellableBag = Set<AnyCancellable>()
    
    // Life Cycle
    init(
        model: TodayModel,
        interactor: TodayInteractable,
        router: TodayRouter
    ) {
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
        
        rootView = TodayRootView(model: model)
        hostingController(rootView: rootView)
        
        fahrenheitNotificationCenter()
        observeDestinationTracking()
        observeCurrentLocationTracking()
        
        Task {
            model = await interactor.execute(action: .viewDidLoad, with: model)
            model = await interactor.execute(action: .requestWeather, with: model)
        }
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
    
    //MARK: Understanding withObservationTracking()
    @discardableResult
    private func observeDestinationTracking() -> TodayModel.Destination? {
        withObservationTracking {
            model.destination
        } onChange: { [weak self] in
            Task {  @MainActor in
                guard let self else { return }
                switch self.model.destination {
                case .setting:
                    break
                case .details(let model):
                    self.router.showDetails(with: model)
                case .todayWeather:
                    self.router.showWeather()
                case .none:
                    break
                }
                self.model.destination = nil
                self.observeDestinationTracking()
            }
        }
    }
    
    @discardableResult
    private func observeCurrentLocationTracking() -> CLLocation? {
        withObservationTracking {
            model.locationState.location
        } onChange: { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                self.model = await self.interactor.execute(action: .requestWeather, with: self.model)
                self.observeCurrentLocationTracking()
            }
        }
    }
}
