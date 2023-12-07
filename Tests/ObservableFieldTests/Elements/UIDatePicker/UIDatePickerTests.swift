//
//  UIDatePickerTests.swift
//  
//
//  Created by GGsrvg on 07.12.2023.
//

import XCTest
import UIKit
import Combine
@testable import ObservableField

class UIDatePickerTests: XCTestCase {
    func test() {
        let container: CancelContainer = CancelContainer()
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let date1 = Date()
        let dateSubject = CurrentValueSubject<Date, Error>(date1)
        
        let property = datePicker.dateControlProperty
        container.activate([
            property <-> dateSubject
        ])
        
        XCTAssert(datePicker.date == date1)
        
        let date2 = Date()
        dateSubject.send(date2)
        XCTAssert(datePicker.date == date2)
        
        let date3 = Date()
        property.set(date3)
        XCTAssert(dateSubject.value == date3)
    }
}
