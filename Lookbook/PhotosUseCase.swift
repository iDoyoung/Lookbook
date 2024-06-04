import Foundation
import Photos
import os

protocol PhotosUseCaseProtocol {
    func execute() async -> PhotosAuthStatus
}

final class PhotosUseCase: PhotosUseCaseProtocol {
    
    private let logger = Logger(subsystem: "Lookbook.PhotosUseCase", category: "Use Case")
    private var repository: PhotosRepositoryProtocol
    
    init(repository: PhotosRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> PhotosAuthStatus {
        do {
            let status = try await repository.authorizationStatus
            logger.log("Get Photos Authorization Status: \(String(describing: status?.rawValue)), from Photos Repository")
            
            switch status {
            case .restricted, .denied: return .restrictedOrDenied
            case .authorized: return .all
            case .limited: return .limited
            case .notDetermined: return .notDetermined
            default: return .unknowned
            }
        } catch {
            return .unknowned
        }
    }
}
