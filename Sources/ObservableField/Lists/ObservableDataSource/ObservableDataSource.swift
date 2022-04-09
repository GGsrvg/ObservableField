//
//  ObservableDataSource.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

/**
 ObservableDataSource is an array wrapper that can notify Adapter of changes.
 
 */
open class ObservableDataSource<H, R, F> where R: Equatable {
    
    public typealias SI = SectionItem<H, R, F>
    
    // TODO: change on Set<>
    internal var callbacks: [ObservableDataSourceDelegate] = []
    
    internal var array: [SI]
    
    internal var isBuildChanges: Bool = false
    internal var arrayOfBuildChanges: [() -> Void] = []
    
    public init() {
        array = []
    }
    
    public init(_ sequence: [SI]) {
        array = sequence
    }
    
    open subscript(index: Int) -> SI {
        array[index]
    }
}

extension ObservableDataSource {
    /*open*/
    func buildChanges(_ changeDataSource: () -> Void) {
        arrayOfBuildChanges = []
        
        isBuildChanges = true
        changeDataSource()
        isBuildChanges = false
        
        initBuildChanges()
    }
    
    func initBuildChanges() {
        defer {
            arrayOfBuildChanges = []
        }
        
        for change in arrayOfBuildChanges {
            change()
        }
    }
}

extension ObservableDataSource: ObservableDataSourceContent {
    open func numberOfSections() -> Int {
        return array.count
    }
    
    open func numberOfRowsInSection(_ section: Int) -> Int {
        // No need to check the range, because if it's out of range, it's not working properly.
        return array[section].rows.count
    }
    
    open func getRow(at indexPath: IndexPath) -> SI.Row? {
        // No need to check the range, because if it's out of range, it's not working properly.
        return self.array[indexPath.section].rows[indexPath.row]
    }
}

extension ObservableDataSource: ObservableDataSourceSubscribe {
    open func addCallback(_ callback: ObservableDataSourceDelegate) {
        guard !callbacks.contains(where: { $0 === callback })
        else { return }

        callbacks.append(callback)
    }

    open func removeCallback(_ callback: ObservableDataSourceDelegate) {
        callbacks.removeAll(where: { $0 === callback })
    }
}

// work with array
// Basic functionality on array
// this functions can call notify for update
extension ObservableDataSource {
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
        notifyAdd(at: indexSet)
    }
    
    open func appendSections(_ sections: [SI]) {
        let beforeCount = array.count
        array.append(contentsOf: sections)
        let afterCout = array.count

        let indexSet = IndexSet(integersIn: beforeCount..<afterCout)
        notifyAdd(at: indexSet)
    }
    // MARK: - Insert section
    open func insertSection(_ newSection: SI, at i: Int) {
        array.insert(newSection, at: i)
        let indexSet = IndexSet(integer: i)
        notifyInsert(at: indexSet)
    }
    
    open func insertSections(_ newSections: [SI], at i: Int) {
        array.insert(contentsOf: newSections, at: i)
        let indexSet = IndexSet(integersIn: i..<(newSections.count + i))
        notifyInsert(at: indexSet)
    }
    // MARK: - Replace section
    open func replaceSection(_ newSection: SI, at i: Int) {
        self.array[i] = newSection
        self.notifyUpdate(at: IndexSet(integer: i))
    }
    // MARK: - Remove section
    open func removeSection(_ sections: [SI]) {
        let removedIndexs: [Int] = self.array
            .enumerated()
            .compactMap {
                guard sections.contains($0.element) else { return nil }
                return $0.offset
            }
        
        self.array.removeAll {  sections.contains($0) }
        self.notifyRemove(at: IndexSet(removedIndexs))
    }
    // MARK: - Append row
    open func addRows(_ rows: [SI.Row], by sectionIndex: Int) {
        let indexPath = IndexPath(row: array[sectionIndex].rows.count - 1, section: sectionIndex)
        array[sectionIndex].rows += rows
        var addIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var addIndexPath = indexPath
            addIndexPath.row += index
            addIndexPaths.append(addIndexPath)
        }
        notifyAddRow(at: addIndexPaths)
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
        notifyUpdateRow(at: [
            indexPath
        ])
    }
    // MARK: - Remove row
    open func removeRow(indexPath: IndexPath) {
        array[indexPath.section].rows.remove(at: indexPath.row)
        notifyRemoveRow(at: [
            indexPath
        ])
    }
}

// work with updating
extension ObservableDataSource {
    open func notifyReload() {
        func notify() {
            callbacks.forEach {
                $0.reload()
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyAdd(at indexSet: IndexSet) {
        func notify() {
            callbacks.forEach {
                $0.addSections(at: indexSet)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyInsert(at indexSet: IndexSet) {
        func notify() {
            callbacks.forEach {
                $0.insertSections(at: indexSet)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyUpdate(at indexSet: IndexSet) {
        func notify() {
            callbacks.forEach {
                $0.updateSections(at: indexSet)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyRemove(at indexSet: IndexSet) {
        func notify() {
            callbacks.forEach {
                $0.removeSections(at: indexSet)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyHeader(section: Int) {
        func notify() {
            callbacks.forEach {
                $0.changeHeader(section: section)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyFooter(section: Int) {
        func notify() {
            callbacks.forEach {
                $0.changeFooter(section: section)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyAddRow(at indexPaths: [IndexPath]) {
        func notify() {
            callbacks.forEach {
                $0.addCells(at: indexPaths)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyInsertRow(at indexPaths: [IndexPath]) {
        func notify() {
            callbacks.forEach {
                $0.insertCells(at: indexPaths)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyUpdateRow(at indexPaths: [IndexPath]) {
        func notify() {
            callbacks.forEach {
                $0.updateCells(at: indexPaths)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
    
    open func notifyRemoveRow(at indexPaths: [IndexPath]) {
        func notify() {
            callbacks.forEach {
                $0.removeCells(at: indexPaths)
            }
        }
        
        if isBuildChanges {
            arrayOfBuildChanges.append(notify)
        } else {
            notify()
        }
    }
}
