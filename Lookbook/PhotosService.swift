/// Reference:
/// https://developer.apple.com/documentation/photokit
/// https://developer.apple.com/documentation/photokit/phphotolibrary/requesting_changes_to_the_photo_library

import Photos
import UIKit
import os

enum PhotosError: Error {
    case error(status: PHAuthorizationStatus)
    case failed
    case unowned
}

protocol PhotosManagerProtocol {
    typealias CompletionHandler = (PHFetchResult<PHAsset>) -> Void
    
    func getStatus() -> PHAuthorizationStatus
    func fetchPhotos() -> PHFetchResult<PHAsset>
}


final class PhotosManager: PhotosManagerProtocol {
    
    private let logger = Logger()
    
    func getStatus() -> PHAuthorizationStatus {
        logger.log("Called Photos Manager To Get Authorization Status")
        return PHPhotoLibrary.authorizationStatus()
    }
   
    func fetchPhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
    
        options.predicate = NSPredicate(format: "mediaType == %d && !(mediaSubtypes == %d)",
                                        PHAssetMediaType.image.rawValue,
                                        PHAssetMediaSubtype.photoScreenshot.rawValue
        )
        
        logger.log("Called Photos Manger To Fetch PHAsst With \(options)")
        return PHAsset.fetchAssets(with: options)
    }
}
