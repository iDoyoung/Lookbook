import Photos
import UIKit

extension PHAsset {
    
    func uiImage(
        size: CGSize = PHImageManagerMaximumSize,
        contentMode: PHImageContentMode = .aspectFit
    ) async -> UIImage {
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        return await withCheckedContinuation { continuation in
            PHImageManager.default().requestImage(
                for: self,
                targetSize: size,
                contentMode: contentMode,
                options: options) { image, _ in
                    guard let image else { return }
                    continuation.resume(returning: image)
                }
        }
    }
    
    func data() async -> Data {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        return await withCheckedContinuation { continuation in
            PHImageManager.default().requestImageDataAndOrientation(
                for: self,
                options: options) { data, _, _, _ in
                    guard let data else { return }
                    continuation.resume(returning: data)
                }
        }
    }
}

extension PHFetchResult where ObjectType == PHAsset {
   
    var assets: [PHAsset] {
        var assets = [PHAsset]()
        assets.reserveCapacity(count)
        
        enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        
        return assets
    }
}
