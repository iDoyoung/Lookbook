import XCTest
import CoreLocation

@testable import Lookbook

final class LocationRepositorySpy: LocationRepositoryProtocol {
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var calledRequestAuthorization = false
    
    func requestAuthorization() {
        calledRequestAuthorization = true
    }
}
