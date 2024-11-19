import Foundation
import Photos
import os
import Vision

protocol PhotosWorking {
    func requestAuthorizationStatus() async -> PHAuthorizationStatus
    func fetchPhotosAssets() async -> [PHAsset]
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
    
    func fetchPhotosAssets() async -> [PHAsset] {
        // 날짜 계산
        // 작년 기준 10일 전에 사진을 뷰에 나타내야한다.
        let today = Date()
        let calendar = Calendar.current
        
        // 작년 값 계산
        guard let aYearAgo = calendar.date(
            byAdding: .year,
            value: -1,
            to: today
        ) else {
            logger.debug("1년 전을 계산 할 수 없습니다")
            return []
        }
        
        // 작년에서 10일 전 날짜 계산
        guard let aYearAndtenDaysAgo = calendar.date(
            byAdding: .day,
            value: -10,
            to: aYearAgo
        ) else {
            logger.debug("1년 하고 10을 전을 계산 할 수 없습니다")
            return []
        }
        
        logger.log("Start fetch photos assets, the \(today) to \(aYearAgo)")
        
        let fetchedAssets = service
            .fetchResult(
                mediaType: .image,
                albumType: nil,
                dateRange: (aYearAndtenDaysAgo, aYearAgo)
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
