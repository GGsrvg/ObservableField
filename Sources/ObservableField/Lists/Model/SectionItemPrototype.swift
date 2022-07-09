//
//  SectionItemPrototype.swift
//  
//
//  Created by GGsrvg on 02.06.2022.
//

import Foundation

public protocol SectionItemPrototype: Hashable {
    associatedtype Header: Hashable
    associatedtype Row: Hashable
    associatedtype Footer: Hashable
    
    var header: Header { get set }
    
    var rows: [Row] { get set }
    
    var footer: Footer { get set }
}
