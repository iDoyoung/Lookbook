import Foundation
import Photos
@testable import Lookbook

final class PhotosServiceSpy: PhotosServiceProtocol {
    
    var calledGetAuthorizationStatus = false
    var calledFetchPhotos = false
    
    var mockAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    var mockFetchedAsset = PHFetchResult<PHAsset>()
    
    func getAuthorizationStatus() async throws -> PHAuthorizationStatus {
        calledGetAuthorizationStatus = true
        return mockAuthorizationStatus
    }
    
    func fetchPhotos() -> PHFetchResult<PHAsset> {
        calledFetchPhotos = false
        return mockFetchedAsset
    }
}
