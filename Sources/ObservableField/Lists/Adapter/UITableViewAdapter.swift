//
//  UITableViewAdapter.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import UIKit

/// Abstract class
///
/// You can use UITableViewClosureAdapter or inheritance
open class UITableViewAdapter<ODS: ObservableDataSourceSubscribe & ObservableDataSourceContent>: NSObject, UITableViewDataSource {
    
    open weak var tableView: UITableView?
    
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
        fatalError("Need override this method")
    }
}

extension UITableViewAdapter: ObservableDataSourceDelegate {
    open func reload() {
        self.tableView?.reloadData()
    }
    
    open func addSections(at indexSet: IndexSet) {
        self.tableView?.insertSections(indexSet, with: .automatic)
    }
    
    open func insertSections(at indexSet: IndexSet) {
        self.tableView?.insertSections(indexSet, with: .automatic)
    }
    
    open func updateSections(at indexSet: IndexSet) {
        self.tableView?.reloadSections(indexSet, with: .automatic)
    }
    
    open func removeSections(at indexSet: IndexSet) {
        self.tableView?.deleteSections(indexSet, with: .automatic)
    }
    
    open func moveSection(_ section: Int, toSection newSection: Int) {
        self.tableView?.moveSection(section, toSection: newSection)
    }
    
    open func changeHeader(section: Int) {
        self.tableView?.reloadSections(.init(integer: section), with: .automatic)
    }
    
    open func changeFooter(section: Int) {
        self.tableView?.reloadSections(.init(integer: section), with: .automatic)
    }
    
    open func addCells(at indexPaths: [IndexPath]) {
        self.tableView?.insertRows(at: indexPaths, with: .automatic)
    }
    
    open func insertCells(at indexPaths: [IndexPath]) {
        self.tableView?.insertRows(at: indexPaths, with: .automatic)
    }
    
    open func updateCells(at indexPaths: [IndexPath]) {
        self.tableView?.reloadRows(at: indexPaths, with: .automatic)
    }
    
    open func removeCells(at indexPaths: [IndexPath]) {
        self.tableView?.deleteRows(at: indexPaths, with: .automatic)
    }
    
    open func moveCell(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        self.tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
}
