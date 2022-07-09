//
//  DifferDataSourceOutput.swift
//  
//
//  Created by GGsrvg on 05.07.2022.
//

import Foundation

public struct DifferDataSourceOutput {
    public struct MovedSection {
        public let from: Int
        public let to: Int
        
        public init(from: Int, to: Int) {
            self.from = from
            self.to = to
        }
    }
    
    public let deletedSections: IndexSet
    public let insertedSections: IndexSet
    public let reloadedSections: IndexSet
    public let movedSections: [MovedSection]
    public let differArrayOutput: DifferArrayOutput
    
    public init(
        deletedSections: IndexSet,
        insertedSections: IndexSet,
        reloadedSections: IndexSet,
        movedSections: [DifferDataSourceOutput.MovedSection],
        differArrayOutput: DifferArrayOutput
    ) {
        self.deletedSections = deletedSections
        self.insertedSections = insertedSections
        self.reloadedSections = reloadedSections
        self.movedSections = movedSections
        self.differArrayOutput = differArrayOutput
    }
}
