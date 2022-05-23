//
//  ObservableField.swift
//  
//
//  Created by Viktor on 10.04.2022.
//

import Foundation

// TODO: add `delay` like RxSwift and Combine
open class ObservableField<TV: Equatable> {
    public typealias NewValueHandler = (TV) -> Void
    
    private var _isCanceled: Bool = false
    public private(set) var value: TV
    var handlers: [NewValueHandler] = []
    
    public init(_ value: TV) {
        self.value = value
    }
    
    public func onNext(_ value: TV) {
        if self.value == value {
            return
        }
        
        self.value = value
        
        notifyHandlers()
    }
    
    public func subscibe(_ handler: @escaping NewValueHandler) {
        handlers.append(handler)
    }
    
    func notifyHandlers() {
        handlers.forEach {
            $0(self.value)
        }
    }
}

extension ObservableField: Cancelable {
    public var isCanceled: Bool {
        _isCanceled
    }
    
    public func cancel() {
        if isCanceled {
            return
        }
        
        defer {
            _isCanceled = true
        }
        
        handlers.removeAll()
    }
    
    
}
