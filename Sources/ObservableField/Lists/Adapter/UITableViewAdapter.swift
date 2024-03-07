//
//  UITableViewAdapter.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import UIKit
import Combine

/// Abstract class
///
/// You can use UITableViewClosureAdapter or inheritance
open class UITableViewAdapter<ODS>:
    NSObject,
    UITableViewDataSource,
    ObservableDataSourceDelegate,
    Cancellable
where ODS: ObservableDataSourceSubscribe,
      ODS: ObservableDataSourceContent {
    private var _isCanceled: Bool = false
    
    open weak var tableView: UITableView?
    
    internal var batchUpdates: [() -> Void] = []
    
    open weak var observableDataSource: ODS? {
        willSet {
            observableDataSource?.removeCallback(self)
        }
        didSet {
            observableDataSource?.addCallback(self)
        }
    }
    
    public init(
        _ tableView: UITableView,
        observableDataSource: ODS
    ) {
        self.tableView = tableView
        self.observableDataSource = observableDataSource
        super.init()
        observableDataSource.addCallback(self)
    }
    
    deinit {
        self.tableView = nil
        self.observableDataSource = nil
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        let count = observableDataSource?.numberOfSections() ?? 0
        return count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = observableDataSource?.numberOfRowsInSection(section) ?? 0
        return count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Need override \(#function) in \(String(describing: self))")
    }
    
    // MARK: - ObservableDataSourceDelegate
    open func reload() {
        self.tableView?.reloadData()
    }
    
    open func insertSections(at indexSet: IndexSet) {
        func action() {
            self.tableView?.insertSections(indexSet, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func reloadSections(at indexSet: IndexSet) {
        func action() {
            self.tableView?.reloadSections(indexSet, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func deleteSections(at indexSet: IndexSet) {
        func action() {
            self.tableView?.deleteSections(indexSet, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func moveSection(_ section: Int, toSection newSection: Int) {
        func action() {
            self.tableView?.moveSection(section, toSection: newSection)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func changeHeader(section: Int) {
        func action() {
            self.tableView?.reloadSections(.init(integer: section), with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func changeFooter(section: Int) {
        func action() {
            self.tableView?.reloadSections(.init(integer: section), with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func insertCells(at indexPaths: [IndexPath]) {
        func action() {
            self.tableView?.insertRows(at: indexPaths, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func reloadCells(at indexPaths: [IndexPath]) {
        func action() {
            self.tableView?.reloadRows(at: indexPaths, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func deleteCells(at indexPaths: [IndexPath]) {
        func action() {
            self.tableView?.deleteRows(at: indexPaths, with: .automatic)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    open func moveCell(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        func action() {
            self.tableView?.moveRow(at: indexPath, to: newIndexPath)
        }
        
        if self.isCollectingBatchUpdate {
            self.batchUpdates.append {
                action()
            }
        } else {
            action()
        }
    }
    
    public var isCollectingBatchUpdate: Bool = false
    
    public func beginCollectingBatchUpdate() {
        isCollectingBatchUpdate = true
    }
    
    public func commitCollectingBatchUpdate() {
        let batchUpdates = self.batchUpdates
        
        self.isCollectingBatchUpdate = false
        self.batchUpdates.removeAll()
        
        self.tableView?.performBatchUpdates(
            {
                batchUpdates.forEach { $0() }
            },
            completion: nil
        )
    }
    
    // MARK: - Cancelable
    public var isCanceled: Bool {
        _isCanceled
    }
    
    public func cancel() {
        if isCanceled {
            return
        }
        
        defer {
            _isCanceled = true
        }
        
        self.tableView = nil
        self.observableDataSource = nil
    }
}
