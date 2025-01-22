import UIKit

final class TodayRouter: Routing {
    
    weak var destination: ViewController?
    var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func showDetails(with model: DetailsModel) {
        let destinationViewController = container.createDetailsViewController(
            asset: model.phAsset,
            weather: model.weather
        )
        
        destination?.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func showWeather() {
        let destinationViewController = container.createTodayWeatherViewController()
        
        destination?.present(destinationViewController, animated: true)
    }
}
