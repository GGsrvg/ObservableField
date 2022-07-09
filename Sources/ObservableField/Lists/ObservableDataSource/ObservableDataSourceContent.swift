//
//  ObservableDataSourceContent.swift
//  
//
//  Created by GGsrvg on 07.04.2022.
//

import Foundation

public protocol ObservableDataSourceContent: AnyObject {
    associatedtype Row: Hashable
    
    func numberOfSections() -> Int

    func numberOfRowsInSection(_ section: Int) -> Int

    func getRow(at indexPath: IndexPath) -> Row
}
