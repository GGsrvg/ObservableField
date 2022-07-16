//
//  UIButtonTests.swift
//  
//
//  Created by GGsrvg on 15.07.2022.
//

import XCTest
import UIKit
@testable import ObservableField

private extension UIControl {
    func simulateEvent(_ event: UIControl.Event) {
        let allTargets = self.allTargets
        for target in allTargets {
            let target = target as NSObjectProtocol
            for actionName in actions(forTarget: target, forControlEvent: event) ?? [] {
                let selector = Selector(actionName)
                target.perform(selector)
            }
        }
    }
}

class UIButtonTests: XCTestCase {
    func testSendAction() {
        let exp = expectation(description: "inverted expectation")
        
        let button = UIButton(frame: .init(x: 0, y: 0, width: 100, height: 100))
        let action = button.addAction(events: .touchUpInside) { button in
            XCTAssertTrue(true)
            exp.fulfill()
        }
        
        let container: CancelContainer = CancelContainer()
        container.activate([
           action
        ])
        
        button.simulateEvent(.touchUpInside)
        
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
