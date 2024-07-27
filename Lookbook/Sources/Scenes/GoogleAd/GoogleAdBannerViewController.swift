// https://developers.google.com/admob/ios/swiftui

import UIKit
import GoogleMobileAds

protocol GoogleAdBannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: GoogleAdBannerViewController, didUpdate width: CGFloat)
}

class GoogleAdBannerViewController: UIViewController {
    
    weak var delegate: GoogleAdBannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.bannerViewController(self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(
            alongsideTransition: { _ in },
            completion: { _ in
                self.delegate?.bannerViewController(self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
            }
        )
    }
}
