import XCTest
import CoreLocation
@testable import Lookbook

final class TodayViewControllerTests: XCTestCase {

    // System Under Test
    
    var sut: TodayViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTodayInteractor = MockTodayInteractor()
        mockRouter = MockRouter(destinationName: SettingViewController.name)
        
        sut = TodayViewController(
            model: mockModel,
            interactor: mockTodayInteractor,
            router: mockRouter
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockTodayInteractor = nil
        try super.tearDownWithError()
    }
    
    // Test Doubles
    
    var mockTodayInteractor: MockTodayInteractor!
    var mockRouter: MockRouter!
    var mockModel = TodayModel()
    
    final class MockTodayInteractor: TodayInteractable {
        
        var called = false
        var receivedAction: TodayViewAction?
        var executeExpectation = XCTestExpectation(description: "Execute called")
            
        func execute(action: Lookbook.TodayViewAction, with model: Lookbook.TodayModel) async -> Lookbook.TodayModel {
            receivedAction = action
            called = true
            executeExpectation.fulfill()
            
            return model
        }
    }
   
    // Tests
    
    func test_viewWillAppear_shouldBeCallInteractorWithViewWillAppearAction() async {
     
        // given
        // when
        await sut.viewWillAppear(false)
        
        // then
        await fulfillment(of: [mockTodayInteractor.executeExpectation])
        
        XCTAssertTrue(mockTodayInteractor.called)
        XCTAssertEqual(TodayViewAction.viewWillAppear, mockTodayInteractor.receivedAction)
    }
    
    func test_observeViewModel_shouldBeCallRouterWhenViewModelUpdatedDestinationToSetting() async {
        
        // given
        let destination: TodayModel.Destination = .setting
        
        // when
        await sut.viewDidLoad()
        mockModel.destination = destination
        await fulfillment(of: [mockRouter.routerExpectation], timeout: 1)
        
        // then
        
        XCTAssertTrue(mockRouter.calledPush)
    }
}
