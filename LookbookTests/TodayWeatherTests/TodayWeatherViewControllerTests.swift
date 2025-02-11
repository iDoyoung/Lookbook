import Foundation
import Testing
@testable import Lookbook

@MainActor
struct TodayWeatherViewControllerLifeCycleTests {
    var sut: TodayWeatherViewController
    var model: TodayWeatherModel
    var interactor: MockTodayWeatherInteractor
    
    init() {
        model = TodayWeatherModel(
            locationState: .init(),
            photosState: .init()
        )
        interactor = MockTodayWeatherInteractor()
        sut = TodayWeatherViewController(
            model: model,
            interactor: interactor
        )
    }
    
    @Test("View Did Load시, Interactor 호출")
    func viewDidLoad() async throws {
        // When
        sut.viewDidLoad()
        
        // Then
        for await _ in interactor.executionFinished {
            #expect(interactor.called)
            #expect(interactor.receivedAction == .viewDidLoad)
            break
        }
    }
}

final class MockTodayWeatherInteractor: TodayWeatherInteractable {
    var called = false
    var receivedAction: TodayWeatherViewAction?
    
    private let continuation = AsyncStream<Void>.makeStream()
    var executionFinished: AsyncStream<Void> { continuation.stream }
    
    func execute(action: Lookbook.TodayWeatherViewAction, with model: Lookbook.TodayWeatherModel) async -> Lookbook.TodayWeatherModel {
        receivedAction = action
        called = true
        continuation.continuation.yield()
        
        return model
    }
}
