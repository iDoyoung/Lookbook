import Foundation
import CoreLocation

@testable import Lookbook

class LocationServiceSpy: CoreLocationServiceProtocol {
    
    var state: LocationServiceState = LocationServiceState()
    var requestLocationCalled = false
    var requestAuthorizationCalled = false
    
    func requestLocation() {
        requestLocationCalled = true
    }
    
    func requestAuthorization() {
        requestAuthorizationCalled = true
    }
    
}
