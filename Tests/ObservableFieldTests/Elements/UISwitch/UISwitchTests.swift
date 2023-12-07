//
//  UISwitchTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UISwitchTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let control = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let subject = CurrentValueSubject<Bool, Error>(false)
        
        let property = control.isOnControlProperty
        container.activate([
            property <-> subject
        ])
        
        XCTAssert(control.isOn == false)
        
        subject.send(true)
        XCTAssert(control.isOn == true)
        
        property.set(false)
        XCTAssert(subject.value == false)
    }
}

