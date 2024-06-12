import XCTest
import Combine
import CoreLocation

@testable import Lookbook

final class LocationRepositorySpy: LocationRepositoryProtocol {
    
    var authorizationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> = CurrentValueSubject(.notDetermined)
    var changedAuthorizationStatus = false
    var calledRequestAuthorization = false
    
    func requestAuthorization() {
        calledRequestAuthorization = true
    }
    
    init() {
        authorizationStatus.sink { [weak self] _ in
            self?.changedAuthorizationStatus = true
        }.cancel()
    }
}
