import Foundation
import Photos

@testable import Lookbook

class PhotosWorkerSpy: PhotosWorking {
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    var fetchPhotosAssetsResult: [PHAsset] = []
    
    var requestAuthorizationStatusCalled = false
    var fetchPhotosAssetsCalled = false
    

    func requestAuthorizationStatus() async -> PHAuthorizationStatus {
        requestAuthorizationStatusCalled = true
        return authorizationStatus
    }
    
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset] {
        fetchPhotosAssetsCalled = true
        return fetchPhotosAssetsResult
    }
}
