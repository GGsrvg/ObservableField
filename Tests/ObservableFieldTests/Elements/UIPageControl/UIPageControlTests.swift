//
//  UIPageControlTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UIPageControlTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let control = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        control.numberOfPages = 10
        let subject = CurrentValueSubject<Int, Error>(0)
        
        let property = control.currentPageControlProperty
        container.activate([
            property <-> subject
        ])
        
        XCTAssert(control.currentPage == 0)
        
        subject.send(1)
        XCTAssert(control.currentPage == 1)
        
        property.set(9)
        XCTAssert(subject.value == 9)
    }
}

