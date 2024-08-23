import Foundation
import Photos
import os
import Vision

class PhotosWorker {
    
    private var service: PhotosServiceProtocol = PhotosService()
    private var predictor = OutfitImagePredictor()
    private let logger = Logger(subsystem: "", category: "worker")
    
    func authorizationStatus() async throws -> PHAuthorizationStatus {
        try await service.authorizationStatus()
    }
    
    func fetchPhotosAssets() async throws -> [PHAsset] {
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
        
        return photoAssets
    }
    
    func fetchAssets() -> [PHAsset] {
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
        
        return service
            .fetchResult(
                mediaType: .image,
                albumType: nil,
                dateRange: (aYearAndtenDaysAgo, today)
            )
            .assets
    }
    
    func imageProcess(photos: [PHAsset]) -> [PHAsset] {
        photos.reduce([PHAsset]()) { 
            accumulatedAssets, currentAsset in
            let originalFPO = featureprintObservationForImage(at: )
            return accumulatedAssets
        }
        
        return []
    }
    
//    func processImages() {
//        guard let originalURL = originalImageURL else {
//            return
//        }
//        /// Generate feature print for original.
//        /// - Tag: FeaturePrintOriginal
//        // Generate a feature print for the original drawing.
//        guard let originalFPO = featureprintObservationForImage(atURL: originalURL) else {
//            return
//        }
//        /// Generate feature print for contestants.
//        /// - Tag: FeaturePrintContestants
//        // Generate feature prints for contestant images.
//        // Next compute their distances from the original feature print.
//        for idx in contestantImageURLs.indices {
//            let contestantImageURL = contestantImageURLs[idx]
//            if let contestantFPO = featureprintObservationForImage(atURL: contestantImageURL) {
//                do {
//                    var distance = Float(0)
//                    try contestantFPO.computeDistance(&distance, to: originalFPO)
//                    ranking.append((contestantIndex: idx, featureprintDistance: distance))
//                } catch {
//                    print("Error computing distance between featureprints.")
//                }
//            }
//        }
//        // Sort results based on distance.
//        ranking.sort { (result1, result2) -> Bool in
//            return result1.featureprintDistance < result2.featureprintDistance
//        }
//        DispatchQueue.main.async {
//            self.presentResults()
//        }
//    }
    
    private func featureprintObservationForImage(at data: Data) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(data: data)
        let request = VNGenerateImageFeaturePrintRequest()
        try? requestHandler.perform([request])
        return request.results?.first
    }
}
