import XCTest
import Swinject

@testable import Lookbook

final class MockRouter: Routing {
    var destination: ViewController?
    var container: Container = .init()
    var calledShow: Bool = false
    var calledPush: Bool = false
    var calledPop: Bool = false
    var calledDismissed: Bool = false
    var routerExpectation = XCTestExpectation(description: "Router called")
    
    func show(viewController name: String) {
        calledShow = true
        routerExpectation.fulfill()
    }
    
    func push(viewController name: String) {
        calledPush = true
        routerExpectation.fulfill()
    }
    
    func pop() {
        calledPop = true
        routerExpectation.fulfill()
    }
    
    func dismiss() {
        calledDismissed = true
        routerExpectation.fulfill()
    }
    
    init(destinationName: String){
        container.register(ViewController.self, name: destinationName) { _ in MockDestinationViewController() }
    }
}

final class MockDestinationViewController: ViewController {
}
