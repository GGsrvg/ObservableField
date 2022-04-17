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
    private var _value: TV
    var handlers: [NewValueHandler] = []
    
    public init(_ value: TV) {
        self._value = value
    }
    
    public func onNext(_ value: TV) {
        if _value == value {
            return
        }
        
        _value = value
        
        notifyHandlers()
    }
    
    public func subscibe(_ handler: @escaping NewValueHandler) {
        handlers.append(handler)
    }
    
    func notifyHandlers() {
        handlers.forEach {
            $0(self._value)
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
