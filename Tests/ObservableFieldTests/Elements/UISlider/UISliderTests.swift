//
//  UISliderTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UISliderTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let control = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        control.minimumValue = 0.0
        control.value = 0.0
        control.maximumValue = 100.0
        let subject = CurrentValueSubject<Float, Error>(0)
        
        let property = control.valueControlProperty
        container.activate([
            property <-> subject
        ])
        
        XCTAssert(control.value == 0)
        
        subject.send(1)
        XCTAssert(control.value == 1)
        
        property.set(9)
        XCTAssert(subject.value == 9)
    }
}

