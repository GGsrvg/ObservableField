//
//  UICollectionViewAdapter.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import UIKit

open class UICollectionViewAdapter<ODS: ObservableDataSourceSubscribe & ObservableDataSourceContent>: NSObject, UICollectionViewDataSource {
    
    open weak var collectionView: UICollectionView?
    
    open weak var observableDataSource: ODS? {
        willSet {
            observableDataSource?.removeCallback(self)
        }
        didSet {
            observableDataSource?.addCallback(self)
        }
    }
    
    public init(
        _ collectionView: UICollectionView,
        observableDataSource: ODS
    ) {
        self.collectionView = collectionView
        self.observableDataSource = observableDataSource
        super.init()
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = observableDataSource?.numberOfSections() ?? 0
        return count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = observableDataSource?.numberOfRowsInSection(section) ?? 0
        return count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Need override this method")
    }
}

extension UICollectionViewAdapter: ObservableDataSourceDelegate {
    open func reload() {
        self.collectionView?.reloadData()
    }
    
    open func addSections(at indexSet: IndexSet) {
        self.collectionView?.insertSections(indexSet)
    }
    
    open func insertSections(at indexSet: IndexSet) {
        self.collectionView?.insertSections(indexSet)
    }
    
    open func updateSections(at indexSet: IndexSet) {
        self.collectionView?.reloadSections(indexSet)
    }
    
    open func removeSections(at indexSet: IndexSet) {
        self.collectionView?.deleteSections(indexSet)
    }
    
    open func moveSection(_ section: Int, toSection newSection: Int) {
        self.collectionView?.moveSection(section, toSection: newSection)
    }
    
    open func changeHeader(section: Int) {
        self.collectionView?.reloadSections(.init(integer: section))
    }
    
    open func changeFooter(section: Int) {
        self.collectionView?.reloadSections(.init(integer: section))
    }
    
    open func addCells(at indexPaths: [IndexPath]) {
        self.collectionView?.insertItems(at: indexPaths)
    }
    
    open func insertCells(at indexPaths: [IndexPath]) {
        self.collectionView?.insertItems(at: indexPaths)
    }
    
    open func updateCells(at indexPaths: [IndexPath]) {
        self.collectionView?.reloadItems(at: indexPaths)
    }
    
    open func removeCells(at indexPaths: [IndexPath]) {
        self.collectionView?.deleteItems(at: indexPaths)
    }
    
    open func moveCell(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        self.collectionView?.moveItem(at: indexPath, to: newIndexPath)
    }
}
