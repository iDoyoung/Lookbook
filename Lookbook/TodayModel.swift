import Foundation

@Observable
class TodayModel {
    var photosAuthorizationStatus: PhotosAuthStatus = .unknowned
    var locationAuthorizationStatus: LocationAuthorizationStatus = .unauthorized
}
