//
//  ObservableField.swift
//  
//
//  Created by GGsrvg on 10.04.2022.
//

import Foundation

// TODO: add `delay` like RxSwift and Combine
/**
 It simple observable.
 */
open class ObservableField<TV: Equatable> {
    private var _isCanceled: Bool = false
    public private(set) var value: TV
    private var handlers: [Handler<TV>] = []
    
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
    
    public func subscibe(_ handler: Handler<TV>) {
        handlers.append(handler)
    }
    
    public func unsubscribe(_ handler: Handler<TV>) {
        handlers.removeAll { _handler in
            _handler === handler
        }
    }
    
    func notifyHandlers() {
        handlers.forEach {
            $0.call(value: self.value)
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
