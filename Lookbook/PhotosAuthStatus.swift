import Foundation

@frozen
enum PhotosAuthStatus {
    case all
    case limited
    case restrictedOrDenied
    case notDetermined
    case unknowned
}
