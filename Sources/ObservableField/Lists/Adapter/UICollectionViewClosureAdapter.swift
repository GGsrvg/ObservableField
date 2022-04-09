//
//  UICollectionViewClosureAdapter.swift
//  
//
//  Created by GGsrvg on 04.04.2022.
//

import UIKit

open class UICollectionViewClosureAdapter<ODS: ObservableDataSourceSubscribe & ObservableDataSourceContent>
    : UICollectionViewAdapter<ODS> {
   
    public typealias CellForRowHandler = ((UICollectionView, IndexPath, ODS.Row) -> UICollectionViewCell)
    public typealias ViewForSupplementaryElementOfKindHandler = ((UICollectionView, String, IndexPath) -> UICollectionReusableView)
    /// UICollectionView is object, Int is number of sections
    public typealias NumberOfSectionsHandler = ((UICollectionView, Int) -> Int)
    /// UICollectionView is object, first Int is number of sections, second Int is number of items in section
    public typealias NumberOfItemsInSectionHandler = ((UICollectionView, Int, Int) -> Int)
    
    open private(set) var cellForRowHandler: CellForRowHandler
    open private(set) var viewForSupplementaryElementOfKindHandler: ViewForSupplementaryElementOfKindHandler?
    open private(set) var numberOfSectionsHandler: NumberOfSectionsHandler?
    open private(set) var numberOfItemsInSectionHandler: NumberOfItemsInSectionHandler?
    
    public init(
        _ collectionView: UICollectionView,
        observableDataSource: ODS,
        cellForRowHandler: @escaping CellForRowHandler,
        viewForSupplementaryElementOfKindHandler: ViewForSupplementaryElementOfKindHandler? = nil,
        numberOfSectionsHandler: NumberOfSectionsHandler? = nil,
        numberOfItemsInSectionHandler: NumberOfItemsInSectionHandler? = nil
    ) {
        self.cellForRowHandler = cellForRowHandler
        self.viewForSupplementaryElementOfKindHandler = viewForSupplementaryElementOfKindHandler
        self.numberOfSectionsHandler = numberOfSectionsHandler
        self.numberOfItemsInSectionHandler = numberOfItemsInSectionHandler
        super.init(collectionView, observableDataSource: observableDataSource)
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = super.numberOfSections(in: collectionView)
        let overriddenCount = self.numberOfSectionsHandler?(collectionView, count)
        return overriddenCount ?? count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = super.collectionView(collectionView, numberOfItemsInSection: section)
        let overriddenCount = self.numberOfItemsInSectionHandler?(collectionView, section, count)
        return overriddenCount ?? count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let rowItem = observableDataSource?.getRow(at: indexPath)
        else { return UICollectionViewCell() }
        
        return self.cellForRowHandler(collectionView, indexPath, rowItem)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = self.viewForSupplementaryElementOfKindHandler?(collectionView, kind, indexPath)
        return cell ?? UICollectionReusableView()
    }
}
