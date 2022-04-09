//
//  ObservableDataSource+SugarFind.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

// sugar
extension ObservableDataSource {
    open func findSectionIndex(_ section: SI) -> Int? {
        guard let index = self.array.firstIndex(of: section)
        else { return nil }
        
        return index
    }
    
    open func findSectionIndex(when predicate: (SI) throws -> Bool) -> Int? {
        guard let index = try? self.array.firstIndex(where: predicate)
        else { return nil }
        
        return index
    }
    
    open func findSection(when predicate: (SI) throws -> Bool) -> SI? {
        guard let index = try? self.array.firstIndex(where: predicate)
        else { return nil }
        
        return self[index]
    }
    
    open func findRowIndexPath(_ elementRow: SI.Row) -> IndexPath? {
        for (sectionIndex, section) in self.array.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if row == elementRow {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    open func findRowIndexPath(when predicate: (SI.Row) throws -> Bool) -> IndexPath? {
        for (sectionIndex, section) in self.array.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if let result = try? predicate(row), result {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    open func findRow(when predicate: (SI.Row) throws -> Bool) -> SI.Row? {
        for (_, section) in self.array.enumerated() {
            for (_, row) in section.rows.enumerated() {
                if let result = try? predicate(row), result {
                    return row
                }
            }
        }
        return nil
    }
}
