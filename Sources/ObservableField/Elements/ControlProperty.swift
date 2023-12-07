//
//  ControlProperty.swift
//  
//
//  Created by GGsrvg on 17.04.2022.
//

import UIKit
import Combine

/**
 It is a wrapper over UIControl and UIControl.Event. Which will track and notify changes.
 
 - TC - is control type
 - TV - is value type
 */
open class ControlProperty<TC, TV>: Cancellable where TC: UIControl, TV: Equatable {
    public typealias GetCallback = (TC) -> TV
    public typealias SetCallback = (TC, TV) -> Void
    public typealias NewValueHandler = (TV) -> Void
    
    let selector = #selector(eventHandler)
    
    var newValueHandler: NewValueHandler?
    
    private(set) unowned var control: TC
    let events: UIControl.Event
    let getCallback: GetCallback?
    let setCallback: SetCallback?
    
    public init(
        control: TC,
        with events: UIControl.Event,
        get getCallback: @escaping GetCallback,
        set setCallback: @escaping SetCallback
    ) {
        self.control = control
        self.events = events
        self.getCallback = getCallback
        self.setCallback = setCallback
        
        control.addTarget(self, action: selector, for: events)
    }
    
    @objc private func eventHandler() {
        guard !isCanceled,
              let getCallback = getCallback,
              let newValueHandler = newValueHandler
        else { return }
        
        let value = getCallback(control)
        newValueHandler(value)
    }
    
    func set(_ value: TV) {
        guard !isCanceled,
              let getCallback = getCallback,
              let setCallback = setCallback
        else { return }
        
        let currentValue = getCallback(control)
        if currentValue == value {
            return
        }
        
        setCallback(control, value)
        eventHandler()
    }
    
    // MARK: - Cancellable
    public private(set) var isCanceled: Bool = false
    
    public func cancel() {
        if isCanceled { return }
        isCanceled = true
        
        control.removeTarget(self, action: selector, for: self.events)
        newValueHandler = nil
    }
}
