//
//  ObservableArray.swift
//  
//
//  Created by GGsrvg on 05.04.2022.
//

import Foundation

/**
 The observable array above the rows.
 
 ObservableArray is an array of data. Data that is presented in rows.
 
 An ObservableArray can be subscribed to by a UICollectionViewAdapter/UITableViewAdapter and receive updated data.
 
 ObservableArray stores all data in RAM.
 */
open class ObservableArray<R> where R: Hashable {
    
    public typealias Row = R
    
    // TODO: change Array on Set
    internal var callbacks: [ObservableDataSourceDelegate] = []
    
    public internal(set) var array: [Row]
    
    open var differ: DifferArray? = nil
    
    public init() {
        array = []
    }
    
    public init(_ sequence: [Row]) {
        array = sequence
    }
    
    deinit {
        array.removeAll()
        callbacks.removeAll()
    }
    
    open subscript(index: Int) -> Row {
        array[index]
    }
    
    public var count: Int { array.count }
}

extension ObservableArray {
    /**
     When you know what needs to be changed and in what order.
     Unlike setAndUpdateDiffable, this does not require diffing.
     */
    public func buildChanges(_ changeDataSource: () -> Void) {
        callbacks.forEach { $0.beginCollectingBatchUpdate() }
        changeDataSource()
        callbacks.forEach { $0.commitCollectingBatchUpdate() }
    }
}

extension ObservableArray: ObservableDataSourceContent {
    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfRowsInSection(_ section: Int) -> Int {
        // No need to check the range, because if it's out of range, it's not working properly.
        return self.count
    }
    
    open func getRow(at indexPath: IndexPath) -> Row {
        // No need to check the range, because if it's out of range, it's not working properly.
        return self[indexPath.row]
    }
}

extension ObservableArray: ObservableDataSourceSubscribe {
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
extension ObservableArray {
    // MARK: -
    open func set(_ elements: [Row]) {
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
    // MARK: - Append row
    open func appendRows(_ rows: [Row]) {
        let lastIndexPath = IndexPath(row: array.count - 1, section: 0)
        array += rows
        var addIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var addIndexPath = lastIndexPath
            addIndexPath.row += index
            addIndexPaths.append(addIndexPath)
        }
        notifyInsertRow(at: addIndexPaths)
    }
    // MARK: - Insert row
    open func insertRows(_ rows: [Row], at index: Int) {
        array.insert(contentsOf: rows, at: index)
        var insertIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var insertIndexPath = IndexPath(row: index, section: 0)
            insertIndexPath.row += index
            insertIndexPaths.append(insertIndexPath)
        }
        notifyInsertRow(at: insertIndexPaths)
    }
    // MARK: - Replace row
    open func replaceRow(_ row: Row, at index: Int) {
        self.array[index] = row
        self.notifyReloadRow(at: [IndexPath(row: index, section: 0)])
    }
    // MARK: - Remove row
    open func deleteRow(at index: Int) {
        array.remove(at: index)
        notifyDeleteRow(at: [ IndexPath(row: index, section: 0) ])
    }
}

// work with updating
extension ObservableArray {
    open func notifyReload() {
        callbacks.forEach {
            $0.reload()
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
}

// MARK: - Differ
extension ObservableArray {
    open func setAndUpdateDiffable(_ elements: [Row]) {
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
        
        guard let differ = self.differ else {
            self.set(elements)
            return
        }
        
        let output = differ.calculate(from: self.array, to: elements)
        
        self.array = elements
        
        callbacks.forEach { $0.beginCollectingBatchUpdate() }
        
        self.notifyDeleteRow(at: output.deletedRows)
        self.notifyReloadRow(at: output.reloadedRows)
        output.movedRows.forEach {
            self.notifyMoveCell(at: $0.from, to: $0.to)
        }
        self.notifyInsertRow(at: output.insertedRows)
        
        callbacks.forEach { $0.commitCollectingBatchUpdate() }
    }
}

