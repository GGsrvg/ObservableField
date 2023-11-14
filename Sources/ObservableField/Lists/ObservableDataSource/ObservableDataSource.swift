//
//  ObservableDataSource.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

/**
 The observable data source above the sections.
 
 ObservableDataSource is an array of data. Data that is presented in sections.
 The section has a header, footer and a list of cells.
 
 An ObservableDataSource can be subscribed to by a UICollectionViewAdapter/UITableViewAdapter and receive updated data.
 
 ObservableDataSource stores all data in RAM.
 */
open class ObservableDataSource<SI: SectionItemPrototype>:
    ObservableDataSourceContent,
    ObservableDataSourceSubscribe
{
    
    // TODO: change Array on Set
    internal var callbacks: [ObservableDataSourceDelegate] = []
    
    public internal(set) var array: [SI]
    
    open var differ: DifferDataSource? = nil
    
    open var differArray: DifferArray? = nil
    
    public init() {
        array = []
    }
    
    public init(_ sequence: [SI]) {
        array = sequence
    }
    
    deinit {
        array.removeAll()
        callbacks.removeAll()
    }
    
    open subscript(index: Int) -> SI {
        array[index]
    }
    
    /**
     Return count sections
     */
    public var count: Int { array.count }
    
    /**
     Return count rows in section
     */
    public func count(at index: Int) -> Int {
        array[index].rows.count
    }
    
    /**
     When you know what needs to be changed and in what order.
     Unlike setAndUpdateDiffable, this does not require diffing.
     */
    public func buildChanges(_ changeDataSource: () -> Void) {
        callbacks.forEach { $0.beginCollectingBatchUpdate() }
        changeDataSource()
        callbacks.forEach { $0.commitCollectingBatchUpdate() }
    }
    
    // MARK: - ObservableDataSourceContent
    open func numberOfSections() -> Int { self.count }
    
    // No need to check the range, because if it's out of range, it's not working properly.
    open func numberOfRowsInSection(_ section: Int) -> Int { self.count(at: section) }
    
    // No need to check the range, because if it's out of range, it's not working properly.
    open func getRow(at indexPath: IndexPath) -> SI.Row? {
        self.array[indexPath.section].rows[indexPath.row]
    }
    
    // MARK: - ObservableDataSourceSubscribe
    open func addCallback(_ callback: ObservableDataSourceDelegate) {
        guard !callbacks.contains(where: { $0 === callback })
        else { return }

        callbacks.append(callback)
    }

    open func removeCallback(_ callback: ObservableDataSourceDelegate) {
        callbacks.removeAll(where: { $0 === callback })
    }
    

    // work with array
    // Basic functionality on array
    // this functions can call notify for update
    // MARK: -
    open func set(_ elements: [SI]) {
        array = elements
        notifyReload()
    }
    
    open func reload() {
        notifyReload()
    }
    
    open func clear() {
        array = []
        notifyReload()
    }
    // MARK: - Header/Footer update
    open func set(header: SI.Header, at index: Int) {
        array[index].header = header
        self.notifyHeader(section: index)
    }
    
    open func set(footer: SI.Footer, at index: Int) {
        array[index].footer = footer
        self.notifyFooter(section: index)
    }
    
    // MARK: - Append section
    open func appendSection(_ section: SI) {
        let beforeCount = array.count
        array.append(section)
        let afterCout = array.count

        let indexSet = IndexSet(integersIn: beforeCount..<afterCout)
        notifyInsertSections(at: indexSet)
    }
    
    open func appendSections(_ sections: [SI]) {
        let beforeCount = array.count
        array.append(contentsOf: sections)
        let afterCout = array.count

        let indexSet = IndexSet(integersIn: beforeCount..<afterCout)
        notifyInsertSections(at: indexSet)
    }
    // MARK: - Insert section
    open func insertSection(_ newSection: SI, at i: Int) {
        array.insert(newSection, at: i)
        let indexSet = IndexSet(integer: i)
        notifyInsertSections(at: indexSet)
    }
    
    open func insertSections(_ newSections: [SI], at i: Int) {
        array.insert(contentsOf: newSections, at: i)
        let indexSet = IndexSet(integersIn: i..<(newSections.count + i))
        notifyInsertSections(at: indexSet)
    }
    // MARK: - Replace section
    open func replaceSection(_ newSection: SI, at i: Int) {
        self.array[i] = newSection
        self.notifyReloadSections(at: IndexSet(integer: i))
    }
    // MARK: - Remove section
    open func deleteSection(_ sections: [SI]) {
        let removedIndexs: [Int] = self.array
            .enumerated()
            .compactMap {
                guard sections.contains($0.element) else { return nil }
                return $0.offset
            }
        
        self.array.removeAll {  sections.contains($0) }
        self.notifyDeleteSections(at: IndexSet(removedIndexs))
    }
    // MARK: - Append row
    open func appendRows(_ rows: [SI.Row], by sectionIndex: Int) {
        let indexPath = IndexPath(row: array[sectionIndex].rows.count, section: sectionIndex)
        array[sectionIndex].rows += rows
        var addIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var addIndexPath = indexPath
            addIndexPath.row += index
            addIndexPaths.append(addIndexPath)
        }
        notifyInsertRow(at: addIndexPaths)
    }
    // MARK: - Insert row
    open func insertRows(_ rows: [SI.Row], by indexPath: IndexPath) {
        array[indexPath.section].rows.insert(contentsOf: rows, at: indexPath.row)
        var insertIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var insertIndexPath = indexPath
            insertIndexPath.row += index
            insertIndexPaths.append(insertIndexPath)
        }
        notifyInsertRow(at: insertIndexPaths)
    }
    // MARK: - Replace row
    open func replaceRow(_ row: SI.Row, indexPath: IndexPath) {
        array[indexPath.section].rows[indexPath.row] = row
        notifyReloadRow(at: [
            indexPath
        ])
    }
    // MARK: - Remove row
    open func deleteRow(indexPath: IndexPath) {
        array[indexPath.section].rows.remove(at: indexPath.row)
        notifyDeleteRow(at: [
            indexPath
        ])
    }

    // work with updating
    open func notifyReload() {
        callbacks.forEach {
            $0.reload()
        }
    }
    
    open func notifyInsertSections(at indexSet: IndexSet) {
        callbacks.forEach {
            $0.insertSections(at: indexSet)
        }
    }
    
    open func notifyReloadSections(at indexSet: IndexSet) {
        callbacks.forEach {
            $0.reloadSections(at: indexSet)
        }
    }
    
    open func notifyDeleteSections(at indexSet: IndexSet) {
        callbacks.forEach {
            $0.deleteSections(at: indexSet)
        }
    }
    
    open func notifyMoveSections(_ section: Int, toSection newSection: Int) {
        callbacks.forEach {
            $0.moveSection(section, toSection: newSection)
        }
    }
    
    open func notifyHeader(section: Int) {
        callbacks.forEach {
            $0.changeHeader(section: section)
        }
    }
    
    open func notifyFooter(section: Int) {
        callbacks.forEach {
            $0.changeFooter(section: section)
        }
    }
    
    open func notifyInsertRow(at indexPaths: [IndexPath]) {
        callbacks.forEach {
            $0.insertCells(at: indexPaths)
        }
    }
    
    open func notifyReloadRow(at indexPaths: [IndexPath]) {
        callbacks.forEach {
            $0.reloadCells(at: indexPaths)
        }
    }
    
    open func notifyDeleteRow(at indexPaths: [IndexPath]) {
        callbacks.forEach {
            $0.deleteCells(at: indexPaths)
        }
    }
    
    open func notifyMoveCell(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        callbacks.forEach {
            $0.moveCell(at: indexPath, to: newIndexPath)
        }
    }

    // MARK: - Differ
    open func setAndUpdateDiffable(_ elements: [SI]) {
        // check on empty all
        // if empty do nothing
        if elements.isEmpty && self.array.isEmpty {
            return
        }
        // check on empty new elements
        // if empty just clear
        if elements.isEmpty {
            self.clear()
            return
        }
        // check on empty current data
        // if empty just reload
        if self.array.isEmpty {
            self.set(elements)
            return
        }
        
        guard let differ = self.differ,
              let differArray = self.differArray
        else {
            self.set(elements)
            return
        }
        
        let output = differ.calculate(
            from: self.array,
            to: elements,
            differArray: differArray
        )
        
        self.array = elements
        
        callbacks.forEach { $0.beginCollectingBatchUpdate() }
        
        self.notifyDeleteSections(at: output.deletedSections)
        self.notifyReloadSections(at: output.reloadedSections)
        output.movedSections.forEach {
            self.notifyMoveSections($0.from, toSection: $0.to)
        }
        self.notifyInsertSections(at: output.insertedSections)
        
//        self.notifyDeleteRow(at: output.differArrayOutput.deletedRows)
//        self.notifyReloadRow(at: output.differArrayOutput.reloadedRows)
//        output.differArrayOutput.movedRows.forEach {
//            self.notifyMoveCell(at: $0.from, to: $0.to)
//        }
//        self.notifyInsertRow(at: output.differArrayOutput.insertedRows)
        
        callbacks.forEach { $0.commitCollectingBatchUpdate() }
        
    }
}
