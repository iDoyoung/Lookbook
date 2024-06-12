import Foundation
import CoreLocation
import Combine

@testable import Lookbook

final class CoreLocationServiceSpy: CoreLocationServiceProtocol {
    var locationSubject: CurrentValueSubject<CLLocation?, Never> = CurrentValueSubject(nil)
    var authorizationStatusSubject: CurrentValueSubject<CLAuthorizationStatus, Never> = CurrentValueSubject(.notDetermined)
    
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
        return authorizationStatusSubject.value
    }
    
    func startUpdatingLocation() {
        
    }
    
    func stopUpdatingLocation() {
        
    }
}
