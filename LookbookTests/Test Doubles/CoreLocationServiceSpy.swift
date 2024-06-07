import Foundation
import CoreLocation
@testable import Lookbook

final class CoreLocationServiceSpy: CoreLocationServiceProtocol {
    
    
    
    var location: CLLocation? = nil
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var calledRequestAuthorization = false
    var requestCurrentLocationIsCalled = false
    
    func requestAuthorization() {
        calledRequestAuthorization = true
    }
    
    func requestCurrentLocation() {
        requestCurrentLocationIsCalled = true
        
    }
    
    var calledGetAuthorizationStatus = false
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        calledGetAuthorizationStatus = true
        return authorizationStatus
    }
    
    func startUpdatingLocation() {
        
    }
    
    func stopUpdatingLocation() {
        
    }
}
