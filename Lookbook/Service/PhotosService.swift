/// Reference:
/// https://developer.apple.com/documentation/photokit
/// https://developer.apple.com/documentation/photokit/phphotolibrary/requesting_changes_to_the_photo_library

import Foundation
import Photos
import os

enum PhotosOptions {
    case all
    case date(start: Date, end: Date)
}

protocol PhotosServiceProtocol {
    func authorizationStatus() async throws -> PHAuthorizationStatus
    func fetchResult(
        mediaType: PhotosService.MediaType,
        albumType: PhotosService.AlbumType?,
        dateRange: (startDate: Date, endDate: Date)?
    ) -> PHFetchResult<PHAsset>
}

final class PhotosService: PhotosServiceProtocol {
   
    enum AlbumType { case userAlbum(title: String? = nil), smartAlbum(subtype: PHAssetCollectionSubtype) }
    enum MediaType { case all, image, video }
    
    // Private PROPERTIES
    
    private let logger = Logger(subsystem: "io.doyoung.PhotosService", category: "Service")
    
    private let sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false)
    ]
    
    // MARK: Public METHODs
    
    func authorizationStatus() async throws -> PHAuthorizationStatus {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .notDetermined {
            logger.log("Try request Photos Authorization")
            await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        }
        
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func fetchResult(
        mediaType: MediaType,
        albumType: AlbumType?,
        dateRange: (startDate: Date, endDate: Date)?
    ) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = sortDescriptors
        
        var predicates = [NSPredicate]()
        
    /// - setup predicate of media type
        if let mediaTypePredicate = mediaTypePredicate(mediaType) {
            predicates.append(mediaTypePredicate)
        }
        
        /// - setup predicate of date range of creation date
        if let dateRange {
            if dateRange.startDate > dateRange.endDate {
                fatalError("The start date cannot be later than the end date")
            }
            let predicate = dateRangePredicate(
                startDate: dateRange.startDate,
                endDate: dateRange.endDate
            )
            
            predicates.append(predicate)
        }
        
        logger.log("Fetch options's Predicates: \(predicates)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        fetchOptions.predicate = compoundPredicate
        
        if let albumType,
           let assetCollection = fetchAssetCollection(albumType: albumType).firstObject {
            return PHAsset.fetchAssets(
                in: assetCollection,
                options: fetchOptions
            )
        } else {
            return PHAsset.fetchAssets(with: fetchOptions)
        }
    }
    
    // Private METHODS
    
    private func fetchAssetCollection(albumType: AlbumType) -> PHFetchResult<PHAssetCollection> {
        let options = PHFetchOptions()
        switch albumType {
        case .userAlbum(let title):
            
            if let title {
                options.predicate = albumTitlePredicate(title: title)
            }
            
            return PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: options
            )
            
        case .smartAlbum(let subType):
            
            return PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: subType,
                options: nil
            )
        }
    }
}
