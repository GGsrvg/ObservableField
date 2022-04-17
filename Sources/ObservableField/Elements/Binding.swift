//
//  Binding.swift
//  
//
//  Created by Viktor on 11.04.2022.
//

import Foundation
import UIKit

open class Binding<TC, TV> where TC: UIControl, TV: Equatable {
    public enum DirectionType {
        case fromProperty
        case fromObservable
        case fromAll
    }
    
    private var _isCanceled: Bool = false
    
    var directionType: DirectionType
    var property: ControlProperty<TC, TV>
    var observable: ObservableField<TV>
    
    public init(
        type directionType: DirectionType,
        property: ControlProperty<TC, TV>,
        observable: ObservableField<TV>
    ) {
        self.directionType = directionType
        self.property = property
        self.observable = observable
        
        self.configureBinding()
    }
    
    func configureBinding() {
        switch directionType {
        case .fromProperty:
            setBindingFromProperty()
        case .fromObservable:
            setBindingFromObservable()
        case .fromAll:
            setBindingFromAll()
        }
    }
    
    func setBindingFromProperty() {
        self.property.newValueHandler = { newValue in
            self.observable.onNext(newValue)
        }
    }
    
    func setBindingFromObservable() {
        self.observable.subscibe { value in
            self.property.set(value)
        }
    }
    
    func setBindingFromAll() {
        setBindingFromProperty()
        setBindingFromObservable()
    }
}

extension Binding: Cancelable {
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
        
        property.cancel()
        observable.cancel()
    }
}
