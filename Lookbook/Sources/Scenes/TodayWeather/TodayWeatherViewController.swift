import UIKit

final class TodayWeatherViewController: ViewController {

    typealias Model = TodayWeatherModel
    typealias Interactor = TodayWeatherInteractable
    // Components
    private var model: Model
    private var rootView: TodayWeatherRootView?
    private var interactor: Interactor
    
    // Life Cycle
    init(
        model: Model,
        interactor: Interactor
    ) {
        self.model = model
        self.interactor = interactor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView = TodayWeatherRootView(model: model)
        hostingController(rootView: rootView)
        
        Task {  @MainActor in
            model = await interactor.execute(
                action: .viewDidLoad,
                with: model
            )
        }
    }
}
