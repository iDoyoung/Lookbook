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
}
