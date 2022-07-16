//
//  DifferArrayTests.swift
//  
//
//  Created by GGsrvg on 16.07.2022.
//

import XCTest
import UIKit
@testable import ObservableField

class DifferArrayTests: XCTestCase {
    func testDiff() {
        let originArray = [
            "red",
            "green",
            "blue",
            "black",
        ]
        let newArray = [
            "green",
            "purple",
            "blue",
            "yellow"
        ]
        let differ: DifferArray = DefaultDifferArray()
        let diff = differ.calculate(from: originArray, to: newArray)
        let diffVerification = DifferArrayOutput(
            deletedRows: [
                IndexPath(row: 0, section: 0), // red
                IndexPath(row: 3, section: 0) // black
            ],
            insertedRows: [
                IndexPath(row: 3, section: 0), // yellow
                IndexPath(row: 1, section: 0), // purple
            ],
            reloadedRows: [],
            movedRows: [
                // green
                DifferArrayOutput.MovedRow(
                    from: IndexPath(row: 1, section: 0),
                    to: IndexPath(row: 0, section: 0)
                )
            ]
        )
        XCTAssert(diff.deletedRows.sorted() == diffVerification.deletedRows.sorted())
        XCTAssert(diff.insertedRows.sorted() == diffVerification.insertedRows.sorted())
        XCTAssert(diff.reloadedRows.sorted() == diffVerification.reloadedRows.sorted())
        XCTAssert(diff.movedRows == diffVerification.movedRows)
    }
}
