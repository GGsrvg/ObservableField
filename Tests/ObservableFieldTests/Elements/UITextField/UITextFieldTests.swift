//
//  UITextFieldTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UITextFieldTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let control = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let text0 = "init"
        let subject = CurrentValueSubject<String?, Error>(text0)
        
        let property = control.textControlProperty
        container.activate([
            property <-> subject
        ])
        
        XCTAssert(control.text == text0)
        
        let text1 = "pop"
        subject.send(text1)
        XCTAssert(control.text == text1)
        
        let text2 = "top"
        property.set(text2)
        XCTAssert(subject.value == text2)
    }
}

