import UIKit
import os

class ViewController: UIViewController {
    
    let defaultLogger = Logger(subsystem: "", category: "View Controller")

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLogger.log("\(type(of: self)), View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultLogger.log("\(type(of: self)), View will appear")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        defaultLogger.log("\(type(of: self)), View is appearing")
    }
    
//    private func fetchPhotos() {
//        Task {
//            switch photosManger.getStatus() {
//            case .notDetermined:
//                await photosManger.requestAuthorizationStatus()
//                fetchPhotos()
//            case .denied, .restricted:
//                break
//            case .authorized, .limited:
//                let photoAssets = photosManger.fetchPhotos()
////                requestImages(for: photoAssets)
//            @unknown default:
//                break
//            }
//        }
//    }
//    
//    private func classifyImage(_ image: UIImage) {
//        do {
//            try self.imagePredictor.makePredictions(
//                for: image)
//        } catch {
//            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
//        }
//    }
//    
//    private let imageManager = PHImageManager.default()
//    
//    private func requestImages(for assets: PHFetchResult<PHAsset>) {
//        let requestOptions = PHImageRequestOptions()
//        
//        for index in 0..<assets.count {
//            let asset = assets[index]
//            defaultLogger.debug("\(String(describing: asset.creationDate))")
//            
//            imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .default, options: requestOptions) { [weak self] image, _ in
//                if let image = image {
//                    DispatchQueue.global(qos: .userInitiated).async {
////                        self?.classifyImage(image)
//                    }
//                }
//            }
//        }
//    }
//    
    deinit {
        defaultLogger.log("Deallocating instance of '\(type(of: self))'")
    }
}

