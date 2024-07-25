import Foundation
import Photos
@testable import Lookbook

final class PhotosServiceSpy: PhotosServiceProtocol {
    
    var calledGetAuthorizationStatus = false
    var calledFetchPhotos = false
    
    var mockAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    var mockFetchedAsset = PHFetchResult<PHAsset>()
    
    func authorizationStatus() async throws -> PHAuthorizationStatus {
        calledGetAuthorizationStatus = true
        return mockAuthorizationStatus
    }
    
    func fetchResult() -> PHFetchResult<PHAsset> {
        calledFetchPhotos = false
        return mockFetchedAsset
    }
}
