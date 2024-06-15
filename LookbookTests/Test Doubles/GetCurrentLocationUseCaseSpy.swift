import Foundation
@testable import Lookbook

class GetCurrentLocationUseCaseSpy: GetCurrentLocationUseCaseProtocol {
    
    var calledExecute = false
    var mockLocation = ""
    
    func execute(completion: @escaping (String) -> Void) {
        calledExecute = true
        mockLocation = "발더스게이트"
    }
}
