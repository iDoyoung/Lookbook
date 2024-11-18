import Photos

@Observable
final class PhotosState {
    var authorizationStatus: PHAuthorizationStatus?
    var assets: [PHAsset]?
    
    func assets(_ assets: [PHAsset]) -> Self {
        self.assets = assets
        return self
    }
    
    func authorizationStatus(_ status: PHAuthorizationStatus) -> Self {
        self.authorizationStatus = status
        return self
    }
}
