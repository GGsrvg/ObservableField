//
//  CancelTests.swift
//  
//
//  Created by GGsrvg on 21.06.2022.
//

import Combine
import XCTest
@testable import ObservableField

class CancelTests: XCTestCase {
    class TestCancelable: Cancellable {
        var isCanceled: Bool = false
        
        init() { }
        
        func cancel() {
            isCanceled = true
        }
    }
    
    func testActivate() {
        let object = AnyCancellable(TestCancelable())
        let container = CancelContainer()
        container.activate(object)
        XCTAssert(container.cancellables.count == 1)
    }
    
    func testMultiActivate() {
        let object1 = AnyCancellable(TestCancelable())
        let object2 = AnyCancellable(TestCancelable())
        let container = CancelContainer()
        container.activate([
            object1,
            object2,
        ])
        XCTAssert(container.cancellables.count == 2)
    }
    
    func testCancel() {
        let object1 = AnyCancellable(TestCancelable())
        let object2 = AnyCancellable(TestCancelable())
        let container: CancelContainer = CancelContainer()
        container.activate([
            object1,
            object2,
        ])
        container.cancel()
        XCTAssertTrue(container.isCancelled)
    }
    
    func testControlProperty() {
        var textField: UITextField! = UITextField()
        let property = textField.textControlProperty
        var container: CancelContainer? = CancelContainer()
        container?.activate([
            property
        ])
        container = nil
        textField = nil
        
        XCTAssertTrue(property.isCanceled)
//        XCTAssertNil(property.getCallback)
//        XCTAssertNil(property.setCallback)
        XCTAssertNil(property.newValueHandler)
    }
    
    func testControlAction() {
        let button = UIButton()
        let action = button.addAction(events: .touchUpInside) { button in
            
        }
        var container: CancelContainer? = CancelContainer()
        container?.activate([
            action
        ])
        container = nil
        XCTAssertTrue(action.isCanceled)
        XCTAssertTrue(action.control == nil)
        XCTAssertTrue(action.action == nil)
    }
}
