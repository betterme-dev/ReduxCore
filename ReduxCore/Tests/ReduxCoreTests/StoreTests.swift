//
//  StoreTests.swift
//  
//
//  Copyright © 2021 Betterme. All rights reserved.
//

import XCTest
import Foundation
@testable import ReduxCore

final class StoreTests: XCTestCase {
    private var sut: Store<TestState>!
    private var state: TestState!
    var dispatchedActions: [Action]!
    
    private struct TestState: Equatable {
        let id: String
    }
    
    override func setUp() {
        super.setUp()
        state = TestState(id: UUID().uuidString)
        dispatchedActions = [Action]()
        sut = Store<TestState>(
            state: state,
            reducer: { state, action -> TestState in
                self.dispatchedActions.append(action)
                return state
            }, middlewares: []
        )
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        state = nil
        dispatchedActions = nil
    }
    
    func testObserve() {
        let expectation = XCTestExpectation()
        
        let endObserving = sut.observe(with: { [unowned self] state in
            XCTAssert(self.state == state)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
        endObserving.cancel()
    }
    
    func testDispatchAction() {
        struct TestAction: Action, Equatable {
            let id: String
        }
        let expectedActions = [TestAction(id: "1"), TestAction(id: "2"), TestAction(id: "3")]
        
        sut.dispatch(action: expectedActions[0])
        sut.dispatch(action: expectedActions[1])
        sut.dispatch(action: expectedActions[2])
        
        let expectation = XCTestExpectation()
        
        let endObserving = sut.observe(with: { _ in
            if self.dispatchedActions.count == 3 {
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 1)
        endObserving.cancel()
        
        XCTAssert(dispatchedActions[0] as! TestAction == expectedActions[0])
        XCTAssert(dispatchedActions[1] as! TestAction == expectedActions[1])
        XCTAssert(dispatchedActions[2] as! TestAction == expectedActions[2])
    }
}
