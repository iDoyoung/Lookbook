import Foundation
import CoreLocation
@testable import Lookbook

final class LocationManagerSpy: LocationManagerProtocol {
    
    var location: CLLocation? = nil
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var requestAuthorizationIsCalled = false
    var requestCurrentLocationIsCalled = false
    
    func requestAuthorization() {
        requestAuthorizationIsCalled = true
    }
    
    func requestCurrentLocation() {
        requestCurrentLocationIsCalled = true
        
    }
}
