//
//  CancelContainer.swift
//  
//
//  Created by GGsrvg on 10.04.2022.
//

import Combine

public class CancelContainer: Cancellable {
    
    public private(set) var cancellables: Set<AnyCancellable> = []
    
    public init() { }
    
    deinit {
        self.cancel()
    }
    
    @discardableResult
    public func activate(_ cancellable: AnyCancellable) -> Bool {
        if isCancelled {
            return false
        }
        
        let result = self.cancellables.insert(cancellable)
        return result.inserted
    }
    
    @discardableResult
    public func activate(_ cancellables: [Cancellable]) -> Bool {
        if isCancelled {
            return false
        }
        
        let cancellables = cancellables.map { cancel in
            AnyCancellable(cancel)
        }
        let newSet = self.cancellables.union(cancellables)
        self.cancellables = newSet
        return true
    }
    
    // MARK: - Cancellable
    public private(set) var isCancelled: Bool = false
    
    public func cancel() {
        if isCancelled {
            return
        }
        isCancelled = true
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        cancellables.removeAll()
    }
}
