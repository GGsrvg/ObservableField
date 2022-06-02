//
//  SectionItem.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

/**
 Its section in UITableView and UICollectionView
 
 H - Headeer
 R - Row
 F - Footer
 
 */

open class SectionItem<H, R, F>: SectionItemPrototype where R: Equatable {
    
    public static func == (lhs: SectionItem<H, R, F>, rhs: SectionItem<H, R, F>) -> Bool {
        lhs === rhs
    }
    
    public typealias Header = H
    public typealias Row = R
    public typealias Footer = F
    
    /**
     Header
     */
    open var header: Header
    
    /**
     Rows
     */
    open var rows: [Row]
    
    /**
     Footer
     */
    open var footer: Footer
    
    public init(header: Header, rows: [Row], footer: Footer) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}
