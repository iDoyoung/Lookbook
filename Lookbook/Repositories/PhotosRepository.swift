import Foundation
import Photos
import UIKit

protocol PhotosRepositoryProtocol {
    var authorizationStatus: PHAuthorizationStatus? { get async throws }
}

final class PhotosRepository: PhotosRepositoryProtocol {
    
    // Public
    init(photosService: PhotosServiceProtocol) {
        self.photosService = photosService
    }
    
    var authorizationStatus: PHAuthorizationStatus? {
        get async throws {
            return try await photosService.getAuthorizationStatus()
        }
    }
    
    // Private
    private var photosService: PhotosServiceProtocol
}

extension PhotosRepository {
    
    private func requestImages(for assets: PHFetchResult<PHAsset>) -> [UIImage] {
        var images = [UIImage]()
        let requestOptions = PHImageRequestOptions()
        
        for index in 0..<assets.count {
            let asset = assets[index]
            PHImageManager.default().requestImage(for: asset, targetSize: .zero, contentMode: .default, options: requestOptions) { image, _ in
                if let image = image {
                    images.append(image)
                }
            }
        }
        
        return images
    }
}
