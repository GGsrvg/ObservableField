//
//  DifferArray.swift
//  
//
//  Created by GGsrvg on 29.06.2022.
//

import Foundation

public protocol DifferArray: AnyObject {
    /**
     Calculates the differences between the current rows and the new rows.
     */
    func calculate<Row: Hashable>(
        from currnetRows: [Row],
        to newRows: [Row]
    ) -> DifferArrayOutput
}
