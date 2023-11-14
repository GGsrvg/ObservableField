//
//  ObservableDataSource+AdditionalChangeFunctionality.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

// work with array
// functions cant call notify for update
extension ObservableDataSource {
    
    public func insertSection(_ newSection: SI, before oldSection: SI) {
        guard let index = self.findSectionIndex(oldSection)
        else { return }
        
        self.insertSection(newSection, at: index)
    }
    
    public func insertSection(_ newSection: SI, after oldSection: SI) {
        guard let index = self.findSectionIndex(oldSection)
        else { return }
        
        self.insertSection(newSection, at: index + 1)
    }
    
    public func insertSections(_ newSections: [SI], after oldSection: SI) {
        guard let index = self.findSectionIndex(oldSection)
        else { return }
        
        self.insertSections(newSections, at: index + 1)
    }
    
    public func insertSections(_ newSections: [SI], before oldSection: SI) {
        guard let index = self.findSectionIndex(oldSection)
        else { return }
        
        self.insertSections(newSections, at: index)
    }
    
    public func replaceSection(_ newSection: SI, at oldSection: SI) {
        guard let index = self.findSectionIndex(oldSection)
        else { return }
        
        self.replaceSection(newSection, at: index)
    }
    // MARK: - Update section
    public func updateSection(_ oldSection: SI) {
        self.replaceSection(oldSection, at: oldSection)
    }
    
    public func appendRows(_ rows: [SI.Row], to section: SI) {
        guard let sectionIndex = self.findSectionIndex(section) else { return }
        
        self.appendRows(rows, by: sectionIndex)
    }
    
    public func appendRows(_ rows: [SI.Row], inFirst predicate: (SI) throws -> Bool) {
        guard let sectionIndex = self.findSectionIndex(when: predicate) else { return }
        
        self.appendRows(rows, by: sectionIndex)
    }
    
    public func insertRows(_ rows: [SI.Row], before row: SI.Row) {
        guard let rowIndexPath = self.findRowIndexPath(row) else { return }

        self.insertRows(rows, by: rowIndexPath)
    }
    
    public func insertRows(_ rows: [SI.Row], after row: SI.Row) {
        guard var rowIndexPath = self.findRowIndexPath(row) else { return }
        rowIndexPath.row += 1
        self.insertRows(rows, by: rowIndexPath)
    }
    
    public func insertRows(_ rows: [SI.Row], beforeFirst predicate: (SI.Row) throws -> Bool) {
        guard let rowIndexPath = self.findRowIndexPath(when: predicate) else { return }

        self.insertRows(rows, by: rowIndexPath)
    }
    
    public func insertRows(_ rows: [SI.Row], afterFirst predicate: (SI.Row) throws -> Bool) {
        guard var rowIndexPath = self.findRowIndexPath(when: predicate) else { return }
        rowIndexPath.row += 1
        self.insertRows(rows, by: rowIndexPath)
    }
    
    public func replaceRow(_ newRow: SI.Row, oldRow: SI.Row) {
        guard let indexPath = self.findRowIndexPath(oldRow)
        else { return }
        
        self.replaceRow(newRow, indexPath: indexPath)
    }
    
    public func reloadRow(_ row: SI.Row) {
        self.replaceRow(row, oldRow: row)
    }
    
    public func deleteRow(_ row: SI.Row) {
        guard let indexPath = self.findRowIndexPath(row)
        else { return }
        
        self.deleteRow(indexPath: indexPath)
    }
}
