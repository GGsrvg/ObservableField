//
//  DefaultDifferDataSource.swift
//  
//
//  Created by GGsrvg on 07.07.2022.
//

import Foundation

public class DefaultDifferDataSource: DifferDataSource {
    struct FastAccessSectionIndexSet {
        let section: AnyHashable
        let index: Int
    }
    
    public init() { }
    
    /**
     Calculates the differences between the current sections and the new sections.
     */
    public func calculate<Section: SectionItemPrototype>(
        from currnetSections: [Section],
        to newSections: [Section],
        differArray: DifferArray
    ) -> DifferDataSourceOutput {
        var deletedSections: [Int] = []
        var insertedSections: [Int] = []
        var reloadedSections: [Int] = []
        var movedSections: [DifferDataSourceOutput.MovedSection] = []
        
        var currentRows: [Section.Row] = []
        var newRows: [Section.Row] = []
        // convert to dictionary
        // to quickly get the IndexPath
        let currentDictionary = convertToDictionaryElementsByIndexPath(
            from: currnetSections,
            rows: &currentRows
        )
        let newDictionary = convertToDictionaryElementsByIndexPath(
            from: newSections,
            rows: &newRows
        )
        // and merge for full details
        let fullDictionary = currentDictionary.merging(
            newDictionary,
            uniquingKeysWith: { current, new in
                new
            }
        )
        // loop
        for elementFromFull in fullDictionary {
            let currentFast = currentDictionary[elementFromFull.key]
            let newFast = newDictionary[elementFromFull.key]
            
            let isHaveInCurrent = currentFast != nil
            let isHaveInNew = newFast != nil
            
            switch (isHaveInCurrent, isHaveInNew) {
            case (true, true):
                // update or move
                let currentFast = currentFast!
                let newFast = newFast!
                
                if currentFast.index == newFast.index {
                    if currentFast.section != newFast.section {
                        reloadedSections.append(currentFast.index)
                    }
                } else {
                    let movedSection = DifferDataSourceOutput.MovedSection(
                        from: currentFast.index,
                        to: newFast.index
                    )
                    movedSections.append(movedSection)
                }
            case (true, false):
                // delete
                deletedSections.append(currentFast!.index)
            case (false, true):
                // insert
                insertedSections.append(newFast!.index)
            case (false, false):
                fatalError("""
                
                It can't be
                
                """)
            }
        }
        
        let differArrayOutput = differArray.calculate(
            from: currentRows,
            to: newRows
        )
        
        let output = DifferDataSourceOutput(
            deletedSections: IndexSet(deletedSections),
            insertedSections: IndexSet(insertedSections),
            reloadedSections: IndexSet(reloadedSections),
            movedSections: movedSections,
            differArrayOutput: differArrayOutput
        )
        return output
    }

    private func convertToDictionaryElementsByIndexPath<Section: SectionItemPrototype>(
        from sections: [Section],
        rows: inout [Section.Row]
    ) -> [Int: FastAccessSectionIndexSet] {
        var _rows: [Section.Row] = []
        let elementsByIndexPath = sections
            .enumerated()
            .reduce(
                into: [Int: FastAccessSectionIndexSet](),
                { result, element in
                    _rows += element.element.rows
                    result[element.element.hashValue] = FastAccessSectionIndexSet(
                        section: element.element,
                        index: element.offset
                    )
                }
            )
        rows = _rows
        return elementsByIndexPath
    }
}
