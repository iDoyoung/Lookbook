// https://developers.google.com/admob/ios/swiftui

import SwiftUI
import GoogleMobileAds

struct GoogleAdBannerView: UIViewControllerRepresentable {
    
    private let adUnitID = Bundle.main.object(forInfoDictionaryKey: "Ad unit id") as? String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = GoogleAdBannerViewController()
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(240)
        
        let bannerView = GADBannerView()
        bannerView.adSize = adaptiveSize
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        bannerView.load(GADRequest())
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
