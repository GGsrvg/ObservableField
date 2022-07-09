//
//  Binding.swift
//  
//
//  Created by GGsrvg on 11.04.2022.
//

import Foundation
import UIKit

/**
 Associating a UIControl property with an ObservableField.
 
 There are 3 types of data transfer available:
 - fromProperty: data will only come from UIControl
 - fromObservable: data will only come from Observable
 - fromAll: data will come from UIControl and Observable
 */
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
