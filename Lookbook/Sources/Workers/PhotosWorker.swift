import Foundation
import Photos
import os
import Vision

protocol PhotosWorkerProtocol {
    associatedtype State
    
    func execute(_ useCase: PhotosWorker.UseCase, state: State) async -> State
}

class PhotosWorker {
    
    typealias State = PhotosState
    
    enum UseCase { case fetchPhotosAssets, requestAuthorization }
    
    private var service: PhotosServiceProtocol
    private var predictor: OutfitImagePredictor
    private let logger = Logger(subsystem: "", category: "worker")
    
    init(
        service: PhotosServiceProtocol = PhotosService(),
        predictor: OutfitImagePredictor = OutfitImagePredictor()) {
        self.service = service
        self.predictor = predictor
    }
    
    func execute(_ useCase: UseCase, state: State) async -> State {
        let state = state
        
        switch useCase {
        case .fetchPhotosAssets:
            state.asstes = try? await fetchPhotosAssets()
        case .requestAuthorization:
            state.authorizationStatus = try? await authorizationStatus()
        }
        
        return state
    }
    
    private func authorizationStatus() async throws -> PHAuthorizationStatus {
        try await service.authorizationStatus()
    }
    
    private func fetchPhotosAssets() async throws -> [PHAsset] {
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
}