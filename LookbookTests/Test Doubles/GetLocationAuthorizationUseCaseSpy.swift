import Foundation
@testable import Lookbook

final class GetLocationAuthorizationUseCaseSpy: GetLocationAuthorizationStatusUseCaseProtocol {
    
    var calledExecute = false
    var mockLocationAuthorizationStatus: LocationAuthorizationStatus = .unauthorized
    
    func execute(completion: @escaping (Lookbook.LocationAuthorizationStatus) -> Void) {
        calledExecute = true
        completion(mockLocationAuthorizationStatus)
    }
}
