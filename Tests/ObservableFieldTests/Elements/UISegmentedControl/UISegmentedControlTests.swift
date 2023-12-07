//
//  UISegmentedControlTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UISegmentedControlTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let control = UISegmentedControl(items: ["0", "1", "2"])
        let subject = CurrentValueSubject<Int, Error>(0)
        
        let property = control.selectedSegmentedIndexControlProperty
        container.activate([
            property <-> subject
        ])
        
        XCTAssert(control.selectedSegmentIndex == 0)
        
        subject.send(1)
        XCTAssert(control.selectedSegmentIndex == 1)
        
        property.set(2)
        XCTAssert(subject.value == 2)
    }
}

