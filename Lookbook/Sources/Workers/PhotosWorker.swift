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
                dateRange: nil
            )
            .assets

        var photoAssets = [PHAsset]()

        let batchSize = 50
        let totalCount = fetchedAssets.count
        
        for batchStartIndex in stride(from: 0, to: totalCount, by: batchSize) {
            await withTaskGroup(of: PHAsset?.self) { group in
                let batchEndIndex = min(batchStartIndex + batchSize, totalCount)
                for index in batchStartIndex..<batchEndIndex {
                    let asset = fetchedAssets[index]
                    
                    group.addTask {
                        self.logger.debug("Start Task: \(index)")
                        let data = await asset.data()
                        
                        do {
                            let result = try await self.predictor.makePredictions(for: data)
                            self.logger.debug("Complete Task: \(index), result: \(result)")
                            
                            return result ? asset : nil
                        } catch {
                            return nil
                        }
                    }
                }
                
                for await result in group {
                    if let asset = result {
                        photoAssets.append(asset)
                    }
                }
            }
        }

        logger.debug("Get \(photoAssets.count) PHAssets")
        return photoAssets
    }
}
