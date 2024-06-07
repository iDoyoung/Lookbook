import Foundation
@testable import Lookbook

class LocationUseCaseSpy: LocationUseCaseProtocol {
    
    var calledExecuteRequestAuthorization = false
    
    func executeRequestAuthorization() {
        calledExecuteRequestAuthorization = true
    }
}
