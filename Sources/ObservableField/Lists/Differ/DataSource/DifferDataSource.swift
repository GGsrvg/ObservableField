//
//  DifferDataSource.swift
//  
//
//  Created by GGsrvg on 05.07.2022.
//

import Foundation

public protocol DifferDataSource: AnyObject {
    
    /**
     Calculates the differences between the current sections and the new sections.
     */
    func calculate<Section: SectionItemPrototype>(
        from currnetSections: [Section],
        to newSections: [Section],
        differArray: DifferArray
    ) -> DifferDataSourceOutput
}
