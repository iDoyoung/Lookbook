import Foundation
import Photos
import os
import Vision

protocol PhotosWorking {
    func requestAuthorizationStatus() async -> PHAuthorizationStatus
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset]
}

final class PhotosWorker: PhotosWorking {
    
    enum UseCase { case fetchPhotosAssets, requestAuthorization }
    
    private var service: PhotosServiceProtocol
    private var predictor: OutfitImagePredictor
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.PhotosWorker",
        category: "🌉 Photos"
    )
   
    init(
        service: PhotosServiceProtocol = PhotosService(),
        predictor: OutfitImagePredictor = OutfitImagePredictor()) {
        self.service = service
        self.predictor = predictor
    }
   
    func requestAuthorizationStatus() async -> PHAuthorizationStatus {
        logger.log("Request Photos authorization status")
        return await service.authorizationStatus()
    }
    
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset] {
        let fetchedAssets = service
            .fetchResult(
                mediaType: .image,
                albumType: nil,
                dateRange: (startDate, endDate)
            )
            .assets
        
        var photoAssets = [PHAsset]()
        
        for index in 0..<fetchedAssets.count {
            let asset = fetchedAssets[index]
            let data = await asset.data()
            
            self.predictor.makePredictions(for: data) { isOutfitPhoto in
                if isOutfitPhoto {
                    photoAssets.append(asset)
                }
            }
        }
        
        logger.log("Get \(photoAssets.count) PHAssets")
        return photoAssets
    }
}
