import Foundation
import Photos
@testable import Lookbook

final class PhotosServiceSpy: PhotosServiceProtocol {
   
    var calledGetAuthorizationStatus = false
    var calledFetchPhotos = false
    var mockAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    var mockFetchedAsset = PHFetchResult<PHAsset>()
    
    func authorizationStatus() async throws -> PHAuthorizationStatus {
        return mockAuthorizationStatus
    }
    
    func fetchResult(mediaType: Lookbook.PhotosService.MediaType, albumType: Lookbook.PhotosService.AlbumType?, dateRange: (startDate: Date, endDate: Date)?) -> PHFetchResult<PHAsset> {
        calledFetchPhotos = false
        return mockFetchedAsset
    }
}
