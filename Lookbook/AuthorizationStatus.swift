import Foundation
import Photos

@Observable
class AuthorizationStatusObject {
    
    var photos: PHAuthorizationStatus = .notDetermined
    
    func request() {
    }
}
