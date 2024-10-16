import Foundation
import Combine
import CoreLocation
import Photos
import os

enum TodayViewAction {
    case viewDidLoad, viewIsAppearing, showSetting
}
                              
protocol TodayInteractable: AnyObject {
    associatedtype Model
    func execute(action: TodayViewAction, with model: Model) async -> Model
}

final class TodayInteractor: TodayInteractable {
    
    typealias Model = TodayModel
    
    private var logger = Logger(subsystem: "io.doyoung.Lookbook.TodayInteractor", category: "Use Case")
    private var cancellableBag = Set<AnyCancellable>()
    
    // service
    var photosWorker: PhotosWorker?
    var weatherRepository: WeatherRepositoryProtocol?
    var locationService: (some CoreLocationServiceProtocol)?
   
    func execute(action: TodayViewAction, with model: Model) async -> TodayModel {
        var model = model
        switch action {
        case .viewDidLoad:
            model.locationState = await requestLocationAuthorizationStatus(model.locationState!)
        case .viewIsAppearing:
            model = .init()
        case .showSetting:
            model = .init()
        }
        
        return model
    }
    
    func requestLocationAuthorizationStatus(_ state: LocationServiceState?) async -> LocationServiceState? {
        guard let state = state else { return nil }
        return await locationService?.execute(.requestAuthorization, with: state)
    }
}
