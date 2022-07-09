//
//  CancelTests.swift
//  
//
//  Created by Viktor on 21.06.2022.
//

import XCTest
@testable import ObservableField

class CancelTests: XCTestCase {
    class TestCancelable: Cancelable {
        var isCanceled: Bool = false
        
        init() { }
        
        func cancel() {
            isCanceled = true
        }
    }
    
    func testActivate() {
        let object = TestCancelable()
        let container = CancelContainer()
        container.activate(object)
        XCTAssert(container.cancelables.count == 1)
    }
    
    func testMultiActivate() {
        let object1 = TestCancelable()
        let object2 = TestCancelable()
        let container = CancelContainer()
        container.activate([
            object1,
            object2,
        ])
        XCTAssert(container.cancelables.count == 2)
    }
    
    func testCancel() {
        let object1 = TestCancelable()
        let object2 = TestCancelable()
        var container: CancelContainer? = CancelContainer()
        container?.activate([
            object1,
            object2,
        ])
        container = nil
        XCTAssertTrue(object1.isCanceled)
        XCTAssertTrue(object2.isCanceled)
    }
}
