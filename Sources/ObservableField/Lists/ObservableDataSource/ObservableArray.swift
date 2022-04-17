//
//  ObservableArray.swift
//  
//
//  Created by GGsrvg on 05.04.2022.
//

import Foundation

open class ObservableArray<R> where R: Equatable {
    
    // TODO: change on Set<>
    internal var callbacks: [ObservableDataSourceDelegate] = []
    
    internal var array: [R]
    
    internal var isBuildChanges: Bool = false
    internal var arrayOfBuildChanges: [() -> Void] = []
    
    public init() {
        array = []
    }
    
    public init(_ sequence: [R]) {
        array = sequence
    }
    
    deinit {
        array.removeAll()
        callbacks.removeAll()
    }
    
    open subscript(index: Int) -> R {
        array[index]
    }
    
    public var count: Int { array.count }
}

extension ObservableArray {
    /*open*/
    public func buildChanges(_ changeDataSource: () -> Void) {
        arrayOfBuildChanges = []
        
        isBuildChanges = true
        changeDataSource()
        isBuildChanges = false
        
        initBuildChanges()
    }
    
    public func initBuildChanges() {
        defer {
            arrayOfBuildChanges = []
        }
        
        for change in arrayOfBuildChanges {
            change()
        }
    }
}

extension ObservableArray: ObservableDataSourceContent {
    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfRowsInSection(_ section: Int) -> Int {
        // No need to check the range, because if it's out of range, it's not working properly.
        return array.count
    }
    
    open func getRow(at indexPath: IndexPath) -> R? {
        // No need to check the range, because if it's out of range, it's not working properly.
        return self.array[indexPath.row]
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
    open func set(_ elements: [R]) {
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
    open func addRows(_ rows: [R]) {
        let lastIndexPath = IndexPath(row: array.count - 1, section: 0)
        array += rows
        var addIndexPaths: [IndexPath] = []
        for (index, _) in rows.enumerated() {
            var addIndexPath = lastIndexPath
            addIndexPath.row += index
            addIndexPaths.append(addIndexPath)
        }
        notifyAddRow(at: addIndexPaths)
    }
    // MARK: - Insert row
    open func insertRows(_ rows: [R], at index: Int) {
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
    open func replaceRow(_ row: R, at index: Int) {
        self.array[index] = row
        self.notifyUpdateRow(at: [IndexPath(row: index, section: 0)])
    }
    // MARK: - Remove row
    open func removeRow(at index: Int) {
        array.remove(at: index)
        notifyRemoveRow(at: [ IndexPath(row: index, section: 0) ])
    }
}

// work with updating
extension ObservableArray {
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
        assertionFailure("No need to call this method on ObservableArray")
    }
    
    open func notifyInsert(at indexSet: IndexSet) {
        assertionFailure("No need to call this method on ObservableArray")
    }
    
    open func notifyUpdate(at indexSet: IndexSet) {
        assertionFailure("No need to call this method on ObservableArray")
    }
    
    open func notifyRemove(at indexSet: IndexSet) {
        assertionFailure("No need to call this method on ObservableArray")
    }
    
    open func notifyHeader(section: Int) {
        assertionFailure("No need to call this method on ObservableArray")
    }
    
    open func notifyFooter(section: Int) {
        assertionFailure("No need to call this method on ObservableArray")
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

