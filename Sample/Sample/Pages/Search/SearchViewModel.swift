//
//  SearchViewModel.swift
//  Sample
//
//  Created by Viktor on 17.04.2022.
//

import Foundation
import ObservableField

class SearchViewModel {
    private let names: [String]
    
    let observableSearch = ObservableField<String?>(nil)
    let observableArray = ObservableArray<String>()
    
    init() {
        self.observableArray.differ = DefaultDifferArray()
        do {
            if let startWordsURL = Bundle.main.url(forResource: "fullNames", withExtension: "txt") {
                let text = try String.init(contentsOf: startWordsURL)
                var names: [String] = text
                    .components(separatedBy: "\n")
                
                names = Array(Set(names[...1000]))
                self.names = names
                self.observableArray.set(names)
            } else {
                self.names = []
            }
        } catch {
            self.names = []
            print(error.localizedDescription)
        }
        self.observableSearch.subscibe { name in
            self.filter(by: name)
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    private func filter(by name: String?) {
        let filteredNames: [String]
        
        if let name = name, !name.isEmpty {
            let lowercasedName = name.lowercased()
            filteredNames = names.filter { $0.lowercased().contains(lowercasedName) }
        } else {
            filteredNames = names
        }
        
        print(filteredNames.count)
        let startTime = CFAbsoluteTimeGetCurrent()
        self.observableArray.setAndUpdateDiffable(filteredNames)
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(timeElapsed) s.")
    }
}
