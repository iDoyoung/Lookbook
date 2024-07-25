import Foundation
import Photos
@testable import Lookbook

final class PhotosRepositorySpy: PhotosRepositoryProtocol {
    func fetchPhotos() {
    }
    
    var calledRepository = false
    
    var authorizationStatus: PHAuthorizationStatus? {
        didSet {
            calledRepository = true
        }
    }
}
