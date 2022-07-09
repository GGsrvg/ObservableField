//
//  ObservableArray+SugarFind.swift
//  
//
//  Created by GGsrvg on 09.07.2022.
//

import Foundation

// sugar
extension ObservableArray {
    
    open func findRowIndexPath(_ elementRow: Row) -> IndexPath? {
        for (rowIndex, row) in self.array.enumerated() {
            if row == elementRow {
                return IndexPath(row: rowIndex, section: 0)
            }
        }
        return nil
    }
    
    open func findRowIndexPath(when predicate: (Row) throws -> Bool) -> IndexPath? {
        for (rowIndex, row) in self.array.enumerated() {
            if let result = try? predicate(row), result {
                return IndexPath(row: rowIndex, section: 0)
            }
        }
        return nil
    }
    
    open func findRow(when predicate: (Row) throws -> Bool) -> Row? {
        for (_, row) in self.array.enumerated() {
            if let result = try? predicate(row), result {
                return row
            }
        }
        return nil
    }
}
