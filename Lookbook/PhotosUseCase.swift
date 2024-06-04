import Foundation
import Photos

final class PhotosUseCase {
    
    var repository: PhotosRepositoryProtocol
    
    init(repository: PhotosRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> PhotosAuthStatus {
        do {
            let status = try await repository.authorizationStatus
            
            switch status {
            case .restricted, .denied: return .restrictedOrDenied
            case .authorized: return .all
            case .limited: return .limited
            default: return .unknowned
            }
        } catch {
            return .unknowned
        }
    }
}
