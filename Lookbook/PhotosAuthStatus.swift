import Foundation

@frozen
enum PhotosAuthStatus {
    case all
    case limited
    case restrictedOrDenied
    case unknowned
}
