import Foundation
import Photos
import os
import Vision
import Combine
#if RELEASE
import FirebaseAnalytics
#endif

/// `PhotosService`로 `PHAsset`를 가져와 `OutfitImagePredictor` 작업을 위한 프로토콜.
protocol PhotosWorking {
    /// Photos Library 접근하기 위한 권한을 요청합니다.
    func requestAuthorizationStatus() async -> PHAuthorizationStatus
    
    /// Photos Library 에서 사진을 가져와 `OutfitV1` 모델을 이용해 분류된 사진을 가져옵니다.
    ///
    /// - Parameters:
    ///   - startDate: 사진을 가져올 범위의 시작 날짜
    ///   - endDate: 사진을 가져올 범위의 종료 날짜
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset]
}

/// `PhotosWorking` 기능에 대한 인터페이스를 제공하는 `actor`
actor PhotosWorker: @preconcurrency PhotosWorking {
    
    private let logger = Logger(
        subsystem: "io.doyoung.Lookbook.PhotosWorker",
        category: "🌉 Photos"
    )
    
    private var service: PhotosServiceProtocol
    private var predictor: OutfitImagePredictor
   
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
    
    //TODO: Enhance Performance
    /// '`OutfitV1` 작업 비동기 처리
    ///
    ///  - 610개 사진 작업시 약 15 - 16초 소요(iPhone 14 pro)
    ///  - Core ML로 이미지 분류를 하지 않고 Vision을 이용한 인물 사진 분류시, 유사한 작업시간 소요
    ///  - `withTaskGroup`을 이용해 동시성 작업 수행 -> 오버헤드 발생
    ///  - `stride` 사용해 50 batch 크기로 작업 수행 ->  610개 사진 작업시 약 5-6초 (iPhone 14 Pro)
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset] {
        let dateRange: (Date, Date)?
        
        #if DEVELOP
        // DEVELOP 모드에서는 많은 양의 사진을 처리과정을 테스트하기 위해 시간 범위를 설정하지 않는다.
        logger.info("Running in DEVELOP mode - fetching all images without date filtering")
        dateRange = nil
        #else
        dateRange = (startDate, endDate)
        let startTime = Date()
        #endif
        
        let fetchedAssets = service
            .fetchResult(
                mediaType: .image,
                albumType: nil,
                dateRange: dateRange
            )
            .assets
        
        var photoAssets = [PHAsset]()
        
        // iPhone 14 pro, batch size: 69 지정시 오버헤드 발생
        // batch size 30, 5-6초 소요
        let batchSize = 30
        let totalCount = fetchedAssets.count
        
        logger.info("Starting to process \(totalCount) assets in batches of \(batchSize)")
        
        for batchStartIndex in stride(from: 0, to: totalCount, by: batchSize) {
            await withTaskGroup(of: PHAsset?.self) { group in
                let batchEndIndex = min(batchStartIndex + batchSize, totalCount)
                
                logger.debug("Processing batch \(batchStartIndex) to \(batchEndIndex-1)")
                
                for index in batchStartIndex..<batchEndIndex {
                    let asset = fetchedAssets[index]
                    
                    group.addTask {
                        let data = await asset.data()
                        
                        do {
                            let result = try await self.predictor.makePredictions(for: data)
                            
                            if result {
                                self.logger.debug("Asset at index \(index) identified as outfit image")
                                return asset
                            }
                            return nil
                        } catch {
                            self.logger.error("Error processing asset at index \(index): \(error.localizedDescription)")
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

        logger.info("Processed \(totalCount) assets, identified \(photoAssets.count) outfit images")
#if RELEASE
        let endTime = Date()
        let timeInterval = batchEndTime.timeIntervalSince(startTime)
        let parameters = [
            "message": "completed in\(String(format: "%.2f", timeInterval)) seconds",
            "file": #file,
            "function": #function
        ]
        Analytics.logEvent("time_of_fetch_photos_with_image_classification", parameters: parameters)
#endif
        return photoAssets
    }
}
