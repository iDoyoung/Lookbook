import Foundation

@testable import Lookbook

class PhotosUseCaseSpy: PhotosUseCaseProtocol {
    
    var mockPhotosAuthStatus: PhotosAuthStatus = .unknowned
    var calledUseCase = false
    
    func execute() async -> Lookbook.PhotosAuthStatus {
        calledUseCase = true
        
        return mockPhotosAuthStatus
    }
}
