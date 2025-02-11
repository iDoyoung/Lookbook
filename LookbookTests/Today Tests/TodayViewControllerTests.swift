import XCTest
import CoreLocation
import Testing
@testable import Lookbook

@MainActor
struct TodayViewControllerLifeCycleTests {
    var sut: TodayViewController
    var model: TodayModel
    var interactor: MockTodayInteractor
    var router: MockTodayRouter
    
    init () {
        model = TodayModel(locationState: .init())
        interactor = MockTodayInteractor()
        router = MockTodayRouter()
        sut = TodayViewController(
            model: model,
            interactor: interactor,
            router: router
        )
    }
    
    @Test("View Did Load시 Interactor 호출")
    func viewDidLoad() async {
        // When
        sut.viewDidLoad()
        
        // Then
        for await _ in interactor.executionFinished {
            #expect(interactor.called)
            #expect(interactor.receivedAction == .viewDidLoad)
            break
        }
    }
    
    @Test("View Will Appear시 Interactor 호출")
    func viewWillAppear() async {
       // When
        sut.viewWillAppear(false)
        
        // Then
        for await _ in interactor.executionFinished {
            #expect(interactor.called)
            #expect(interactor.receivedAction == .viewWillAppear)
            break
        }
    }
}

final class MockTodayRouter: TodayRouting {
    var calledShowDetails: Bool = false
    var calledShowWeather: Bool = false
    func showDetails(with model: Lookbook.DetailsModel) {
        calledShowDetails = true
    }
    
    func showWeather() {
        calledShowWeather = true
    }
}

final class MockTodayInteractor: TodayInteractable {
    var called = false
    var receivedAction: TodayViewAction?
    
    private let continuation = AsyncStream<Void>.makeStream()
    var executionFinished: AsyncStream<Void> { continuation.stream }
    
    func execute(action: TodayViewAction, with model: TodayModel) async -> TodayModel {
        receivedAction = action
        called = true
        continuation.continuation.yield()
        return model
    }
}
