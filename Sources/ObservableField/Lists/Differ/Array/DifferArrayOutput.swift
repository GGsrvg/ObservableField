//
//  DifferArrayOutput.swift
//  
//
//  Created by GGsrvg on 29.06.2022.
//

import Foundation

public struct DifferArrayOutput {
    public struct MovedRow: Equatable {
        public let from: IndexPath
        public let to: IndexPath
        
        public init(from: IndexPath, to: IndexPath) {
            self.from = from
            self.to = to
        }
    }
    
    public let deletedRows: [IndexPath]
    public let insertedRows: [IndexPath]
    public let reloadedRows: [IndexPath]
    public let movedRows: [MovedRow]
    
    public init(
        deletedRows: [IndexPath],
        insertedRows: [IndexPath],
        reloadedRows: [IndexPath],
        movedRows: [MovedRow]
    ) {
        self.deletedRows = deletedRows
        self.insertedRows = insertedRows
        self.reloadedRows = reloadedRows
        self.movedRows = movedRows
    }
}
