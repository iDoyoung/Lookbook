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

protocol PhotosServiceProtocol {
    func getAuthorizationStatus() async throws -> PHAuthorizationStatus
    func fetchPhotos() -> PHFetchResult<PHAsset>
}


final class PhotosService: PhotosServiceProtocol {
    
    func getAuthorizationStatus() async throws -> PHAuthorizationStatus  {
        
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .notDetermined {
            await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        }
        
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
  
    func fetchPhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
    
        options.predicate = NSPredicate(
            format: "mediaType == %d && !(mediaSubtypes == %d)",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaSubtype.photoScreenshot.rawValue)
        
        logger.log("Called Photos Manger To Fetch PHAsst With \(options)")
        return PHAsset.fetchAssets(with: options)
    }
    
    // Private
    private let logger = Logger()
}
