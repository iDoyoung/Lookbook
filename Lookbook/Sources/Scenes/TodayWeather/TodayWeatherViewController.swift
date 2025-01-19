import UIKit

final class TodayWeatherViewController: ViewController {

    // Components
    private var model: TodayWeatherModel
    private var rootView: TodayWeatherRootView?
    
    // Life Cycle
    init(
        model: TodayWeatherModel
    ) {
        self.model = model
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView = TodayWeatherRootView(model: model)
        hostingController(rootView: rootView)
    }
}
