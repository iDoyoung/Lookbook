import Foundation
import Photos
import os

class PhotosWorker {
    
    private var service: PhotosServiceProtocol = PhotosService()
    private var predictor = OutfitImagePredictor()
    private let logger = Logger(subsystem: "", category: "worker")
    
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
        
        let datas: [PHAsset] = await withTaskGroup(of: PHAsset?.self) { [weak self] group in
            
            guard let self else { fatalError() }
            let count = fetchedAssets.count > 150 ? 100 : fetchedAssets.count
            for index in 0..<count {
                
                group.addTask {
                    let asset = fetchedAssets[index]
                    let data = await asset.data()
                    
                    var predicate: Bool = false
                    
                    self.predictor.makePredictions(for: data) { res in
                        predicate = res
                    }
                    
                    return  predicate ? asset: nil
                }
            }
            
            return await group
                .reduce(into: [PHAsset?]()) { $0.append($1) }
                .compactMap { $0 }
        }
        
        return datas
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
}
