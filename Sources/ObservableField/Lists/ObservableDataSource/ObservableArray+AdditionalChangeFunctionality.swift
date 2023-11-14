//
//  ObservableArray+AdditionalChangeFunctionality.swift
//  
//
//  Created by GGsrvg on 09.07.2022.
//

import Foundation

// work with array
// functions cant call notify for update
extension ObservableArray {
    
    public func insertRows(_ rows: [Row], before row: Row) {
        guard let indexPath = self.findRowIndexPath(row) else { return }
        
        self.insertRows(rows, at: indexPath.row)
    }
    
    public func insertRows(_ rows: [Row], after row: Row) {
        guard let indexPath = self.findRowIndexPath(row) else { return }
        
        self.insertRows(rows, at: indexPath.row + 1)
    }
    
    public func insertRows(_ rows: [Row], beforeFirst predicate: (Row) throws -> Bool) {
        guard let indexPath = self.findRowIndexPath(when: predicate) else { return }
        
        self.insertRows(rows, at: indexPath.row)
    }
    
    public func insertRows(_ rows: [Row], afterFirst predicate: (Row) throws -> Bool) {
        guard let indexPath = self.findRowIndexPath(when: predicate) else { return }
        
        self.insertRows(rows, at: indexPath.row + 1)
    }
    
    public func replaceRow(_ newRow: Row, oldRow: Row) {
        guard let indexPath = self.findRowIndexPath(oldRow)
        else { return }
        
        self.replaceRow(newRow, at: indexPath.row)
    }
    
    public func reloadRow(_ row: Row) {
        self.replaceRow(row, oldRow: row)
    }
    
    public func deleteRow(_ row: Row) {
        guard let indexPath = self.findRowIndexPath(row)
        else { return }
        
        self.deleteRow(at: indexPath.row)
    }
}
