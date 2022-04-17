//
//  UITableViewClosureAdapter.swift
//  
//
//  Created by GGsrvg on 03.04.2022.
//

import UIKit

open class UITableViewClosureAdapter<ODS>: UITableViewAdapter<ODS>
where ODS: ObservableDataSourceSubscribe & ObservableDataSourceContent {
    
    public typealias CellForRowHandler = ((UITableView, IndexPath, ODS.Row) -> UITableViewCell)
    public typealias TitleForSectionHandler = ((UITableView, Int) -> String?)
    /// UITableView is object, Int is number of sections
    public typealias NumberOfSectionsHandler = ((UITableView, Int) -> Int)
    /// UITableView is object, first Int is number of sections, second Int is number of items in section
    public typealias NumberOfItemsInSectionHandler = ((UITableView, Int, Int) -> Int)
    
    open private(set) var cellForRowHandler: CellForRowHandler?
    open private(set) var titleForHeaderSectionHandler: TitleForSectionHandler?
    open private(set) var titleForFooterSectionHandler: TitleForSectionHandler?
    open private(set) var numberOfSectionsHandler: NumberOfSectionsHandler?
    open private(set) var numberOfItemsInSectionHandler: NumberOfItemsInSectionHandler?
    
    public init(
        _ tableView: UITableView,
        observableDataSource: ODS,
        cellForRowHandler: @escaping CellForRowHandler,
        titleForHeaderSectionHandler: TitleForSectionHandler? = nil,
        titleForFooterSectionHandler: TitleForSectionHandler? = nil,
        numberOfSectionsHandler: NumberOfSectionsHandler? = nil,
        numberOfItemsInSectionHandler: NumberOfItemsInSectionHandler? = nil
    ) {
        self.cellForRowHandler = cellForRowHandler
        self.titleForHeaderSectionHandler = titleForHeaderSectionHandler
        self.titleForFooterSectionHandler = titleForFooterSectionHandler
        self.numberOfSectionsHandler = numberOfSectionsHandler
        self.numberOfItemsInSectionHandler = numberOfItemsInSectionHandler
        super.init(tableView, observableDataSource: observableDataSource)
    }
    
    deinit {
        self.cellForRowHandler = nil
        self.titleForHeaderSectionHandler = nil
        self.titleForFooterSectionHandler = nil
        self.numberOfSectionsHandler = nil
        self.numberOfItemsInSectionHandler = nil
    }
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        let count = super.numberOfSections(in: tableView)
        let overriddenCount = self.numberOfSectionsHandler?(tableView, count)
        return overriddenCount ?? count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = super.tableView(tableView, numberOfRowsInSection: section)
        let overriddenCount = self.numberOfItemsInSectionHandler?(tableView, section, count)
        return overriddenCount ?? count
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForHeaderSectionHandler?(tableView, section)
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.titleForFooterSectionHandler?(tableView, section)
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowItem = observableDataSource?.getRow(at: indexPath),
              let cellForRowHandler = cellForRowHandler
        else { return UITableViewCell() }
        
        return cellForRowHandler(tableView, indexPath, rowItem)
    }
    
    public override func cancel() {
        super.cancel()
        
        self.cellForRowHandler = nil
        self.titleForHeaderSectionHandler = nil
        self.titleForFooterSectionHandler = nil
        self.numberOfSectionsHandler = nil
        self.numberOfItemsInSectionHandler = nil
    }
}
