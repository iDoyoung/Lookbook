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
            //FIXME: Image Manager를 매번 인스턴스
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

extension PHFetchResult<PHAsset> {
    
    var assets: [PHAsset] {
        
        var output = [PHAsset]()
        
        self.enumerateObjects { asset, _, _ in
            output.append(asset)
        }
        
        return output
    }
}
