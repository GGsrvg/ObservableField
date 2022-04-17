//
//  CancelContainer.swift
//  
//
//  Created by Viktor on 10.04.2022.
//

import Foundation

public class CancelContainer {
    var cancelables: [Cancelable] = []
    
    public init() { }
    
    deinit {
        self.cancelAll()
    }
    
    public func activate(_ cancelable: Cancelable) {
        cancelables.append(cancelable)
    }
    
    public func activate(_ cancelables: [Cancelable]) {
        self.cancelables.append(contentsOf: cancelables)
    }
    
    func cancelAll() {
        for cancelable in cancelables {
            cancelable.cancel()
        }
        
        cancelables.removeAll()
    }
}
