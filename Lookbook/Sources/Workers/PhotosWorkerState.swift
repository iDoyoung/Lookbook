import Photos

@Observable
final class PhotosState {
    var authorizationStatus: PHAuthorizationStatus?
    var asstes: [PHAsset]?
}
