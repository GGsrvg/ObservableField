//
//  ObservableDataSourceDelegate.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

public protocol ObservableDataSourceDelegate: AnyObject {
    func reload()
    
    func insertSections(at indexSet: IndexSet)
    func reloadSections(at indexSet: IndexSet)
    func deleteSections(at indexSet: IndexSet)
    func moveSection(_ section: Int, toSection newSection: Int)
    
    func changeHeader(section: Int)
    func changeFooter(section: Int)
    
    func insertCells(at indexPaths: [IndexPath])
    func reloadCells(at indexPaths: [IndexPath])
    func deleteCells(at indexPaths: [IndexPath])
    func moveCell(at indexPath: IndexPath, to newIndexPath: IndexPath)
    
    // MARK: - perform batch update
    var isCollectingBatchUpdate: Bool { get }
    
    func beginCollectingBatchUpdate()
    func commitCollectingBatchUpdate()
}
