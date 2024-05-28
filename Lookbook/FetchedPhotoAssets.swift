import Foundation
import Photos

@Observable
class FetchedPhotoAssets {
    var assets = PHFetchResult<PHAsset>()
}
