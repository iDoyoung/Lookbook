import UIKit
import Photos
import Swinject

final class TodayRouter: Routing {
    
    weak var destination: ViewController?
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func pushDetails(with asset: PHAsset) {
        guard let destination else { fatalError("Destination is nil") }
        
        let destinationViewController = container.resolve(DetailsViewController.self)!
        destinationViewController.model.phAsset = asset
        destination.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
