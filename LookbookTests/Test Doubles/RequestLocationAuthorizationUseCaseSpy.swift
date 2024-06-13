import Foundation
@testable import Lookbook

class RequestLocationAuthorizationUseCaseSpy: RequestLocationAuthorizationUseCaseProtocol {
    
    var calledExecute = false
    
    func execute() {
        calledExecute = true
    }
}
