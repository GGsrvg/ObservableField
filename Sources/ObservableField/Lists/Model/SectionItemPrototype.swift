//
//  SectionItemPrototype.swift
//  
//
//  Created by GGsrvg on 02.06.2022.
//

import Foundation

public protocol SectionItemPrototype: Equatable {
   associatedtype Header
   associatedtype Row: Equatable
   associatedtype Footer
   
   var header: Header { get set }
   
   var rows: [Row] { get set }
   
   var footer: Footer { get set }
}
