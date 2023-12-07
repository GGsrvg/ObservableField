//
//  UIColorWellTests.swift
//  
//
//  Created by GGsrvg on 03.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

@available(iOS 14.0, *)
class UIColorWellTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let colorSubject = CurrentValueSubject<UIColor?, Error>(UIColor.red)
        
        let property = colorWell.colorControlProperty
        container.activate([
            property <-> colorSubject
        ])
        
        XCTAssert(colorWell.selectedColor == UIColor.red)
        
        colorSubject.send(UIColor.blue)
        XCTAssert(colorWell.selectedColor == UIColor.blue)
        
        property.set(UIColor.green)
        XCTAssert(colorSubject.value == UIColor.green)
    }
}
