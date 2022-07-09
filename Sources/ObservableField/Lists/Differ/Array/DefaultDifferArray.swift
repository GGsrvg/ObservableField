//
//  DefaultDifferArray.swift
//  
//
//  Created by GGsrvg on 03.07.2022.
//

import Foundation

public class DefaultDifferArray: DifferArray {
    struct FastAccessRowIndexPath {
        let row: AnyHashable
        let indexPath: IndexPath
    }
    
    public init() { }
    
    /**
     Calculates the differences between the current rows and the new rows.
     */
    public func calculate<Row: Hashable>(
        from currentRows: [Row],
        to newRows: [Row]
    ) -> DifferArrayOutput {
        var deletedRows: [IndexPath] = []
        var insertedRows: [IndexPath] = []
        var reloadedRows: [IndexPath] = []
        var movedRows: [DifferArrayOutput.MovedRow] = []
        // convert to dictionary
        // to quickly get the IndexPath
        let currentDictionary = convertToDictionaryElementsByIndexPath(from: currentRows)
        let newDictionary = convertToDictionaryElementsByIndexPath(from: newRows)
        // and merge for full details
        let fullDictionary = currentDictionary.merging(
            newDictionary,
            uniquingKeysWith: { current, new in
                new
            }
        )
        // loop
        for elementFromFull in fullDictionary {
            let currentFastRow = currentDictionary[elementFromFull.key]
            let newFastRow = newDictionary[elementFromFull.key]
            
            let isHaveInCurrent = currentFastRow != nil
            let isHaveInNew = newFastRow != nil
            
            switch (isHaveInCurrent, isHaveInNew) {
            case (true, true):
                // update or move
                let currentFastRow = currentFastRow!
                let newFastRow = newFastRow!
                
                if currentFastRow.indexPath == newFastRow.indexPath {
                    if currentFastRow.row != newFastRow.row {
                        reloadedRows.append(currentFastRow.indexPath)
                    }
                } else {
                    let movedRow = DifferArrayOutput.MovedRow(
                        from: currentFastRow.indexPath,
                        to: newFastRow.indexPath
                    )
                    movedRows.append(movedRow)
                }
            case (true, false):
                // delete
                deletedRows.append(currentFastRow!.indexPath)
            case (false, true):
                // insert
                insertedRows.append(newFastRow!.indexPath)
            case (false, false):
                fatalError("""
                
                It can't be
                
                """)
            }
        }
        
        let output = DifferArrayOutput(
            deletedRows: deletedRows,
            insertedRows: insertedRows,
            reloadedRows: reloadedRows,
            movedRows: movedRows
        )
        return output
    }

    private func convertToDictionaryElementsByIndexPath<Row: Hashable>(
        from rows: [Row]
    ) -> [Int: FastAccessRowIndexPath] {
        let elementsByIndexPath = rows
            .enumerated()
            .reduce(
                into: [Int: FastAccessRowIndexPath](),
                { result, element in
                    result[element.element.hashValue] = FastAccessRowIndexPath(
                        row: element.element,
                        indexPath: IndexPath(row: element.offset, section: 0)
                    )
                }
            )
        return elementsByIndexPath
    }
}
