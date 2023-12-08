//
//  Binding.swift
//  
//
//  Created by GGsrvg on 11.04.2022.
//

import Foundation
import UIKit
import Combine

/**
 Associating a UIControl property with an Subejct.
 
 There are 3 types of data transfer available:
 - fromProperty: data will only come from UIControl
 - fromSubject: data will only come from Subject
 - fromAll: data will come from UIControl and Subject
 
 TC - Type of Control
 TV - Type of Value
 */
open class Binding<TC, TV>: Cancellable where TC: UIControl, TV: Equatable {
    public enum DirectionType {
        case fromProperty
        case fromSubject
        case fromAll
    }
    
    private lazy var handler = Handler<TV>(name: "Binding TC = \(TC.self) TV = \(TV.self)") {
        [weak self] value in
        
        guard let self else { return }
        
        self.property.set(value)
    }
    
    
    let directionType: DirectionType
    let property: ControlProperty<TC, TV>
    unowned var subject: any Subject<TV, Error>
    
    private let cancelContainer = CancelContainer()
    
    public init(
        type directionType: DirectionType,
        property: ControlProperty<TC, TV>,
        subject: any Subject<TV, Error>
    ) {
        self.directionType = directionType
        self.property = property
        self.subject = subject
        
        self.configureBinding()
    }
    
    func configureBinding() {
        switch directionType {
        case .fromProperty:
            setValueFromProperty()
            
            setBindingFromProperty()
        case .fromSubject:
            setValueFromSubject()
            
            setBindingFromSubject()
        case .fromAll:
            setValueFromSubject()
            
            setBindingFromProperty()
            setBindingFromSubject()
        }
    }
    
    private func setBindingFromProperty() {
        self.property.newValueHandler = { [weak self] newValue in
            guard let self else { return }
            
            self.subject.send(newValue)
        }
    }
    
    private func setBindingFromSubject() {
        self.subject
            .sink { completion in
                switch completion {
                case .finished:
                    print("\(#function) finished")
                case .failure(let fail):
                    print("\(#function) has a problem \(fail.localizedDescription)")
                }
            } receiveValue: { [weak self] output in
                guard let self else { return }
                
                self.handler.call(value: output)
            }
            .store(in: self.cancelContainer)

    }
    
    private func setValueFromProperty() {
        let control = property.control
        if let value = property.getCallback?(control) {
            self.subject.send(value)
        }
    }
    
    private func setValueFromSubject() {
        let control = property.control
        if let valueSubject = self.subject as? CurrentValueSubject<TV, Error> {
            property.setCallback?(control, valueSubject.value)
        }
    }
    
    // MARK: - Cancellable
    public private(set) var isCanceled: Bool = false
    
    public func cancel() {
        if isCanceled { return }
        isCanceled = true
        
        self.property.newValueHandler = nil
        
        self.cancelContainer.cancel()
    }
}
