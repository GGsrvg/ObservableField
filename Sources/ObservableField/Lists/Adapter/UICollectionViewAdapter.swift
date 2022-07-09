//
//  UICollectionViewAdapter.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import UIKit

open class UICollectionViewAdapter<ODS>:
    NSObject,
    UICollectionViewDataSource,
    ObservableDataSourceDelegate,
    Cancelable
where ODS: ObservableDataSourceSubscribe,
      ODS: ObservableDataSourceContent {
    private var _isCanceled: Bool = false
    
    open weak var collectionView: UICollectionView?
    
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
        _ collectionView: UICollectionView,
        observableDataSource: ODS
    ) {
        self.collectionView = collectionView
        self.observableDataSource = observableDataSource
        super.init()
        observableDataSource.addCallback(self)
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
        fatalError("Need override \(#function) in \(#fileID)")
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError("Need override \(#function) in \(#fileID)")
    }
    
    // MARK: - ObservableDataSourceDelegate
    open func reload() {
        self.collectionView?.reloadData()
    }
    
    open func insertSections(at indexSet: IndexSet) {
        func action() {
            self.collectionView?.insertSections(indexSet)
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
            self.collectionView?.reloadSections(indexSet)
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
            self.collectionView?.deleteSections(indexSet)
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
            self.collectionView?.moveSection(section, toSection: newSection)
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
            self.collectionView?.reloadSections(.init(integer: section))
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
            self.collectionView?.reloadSections(.init(integer: section))
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
            self.collectionView?.insertItems(at: indexPaths)
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
            self.collectionView?.reloadItems(at: indexPaths)
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
            self.collectionView?.deleteItems(at: indexPaths)
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
            self.collectionView?.moveItem(at: indexPath, to: newIndexPath)
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
        
        self.collectionView?.performBatchUpdates(
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
        
        self.collectionView = nil
        self.observableDataSource = nil
    }
}
