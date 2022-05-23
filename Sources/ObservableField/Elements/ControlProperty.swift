//
//  File.swift
//  
//
//  Created by Viktor on 17.04.2022.
//

import UIKit

/// (need add)
///
/// TC is control type
/// TV is value type
open class ControlProperty<TC, TV> where TC: UIControl, TV: Any {
    public typealias GetCallback = (TC) -> TV
    public typealias SetCallback = (TC, TV) -> Void
    public typealias NewValueHandler = (TV) -> Void
    
    let selector = #selector(eventHandler)
    
    var newValueHandler: NewValueHandler?
    
    weak var control: TC?
    var events: UIControl.Event
    var getCallback: GetCallback?
    var setCallback: SetCallback?
    
    private var _isCanceled: Bool = false
    
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
        guard let control = control,
              let getCallback = getCallback,
              let newValueHandler = newValueHandler
        else { return }
        
        let value = getCallback(control)
        newValueHandler(value)
    }
    
    func set(_ value: TV) {
        guard let control = control,
              let setCallback = setCallback
        else { return }
        
        setCallback(control, value)
    }
}

extension ControlProperty: Cancelable {
    public var isCanceled: Bool {
        get { _isCanceled }
    }
    
    public func cancel() {
        defer {
            _isCanceled = true
        }
        
        control?.removeTarget(self, action: selector, for: self.events)
        control = nil
        getCallback = nil
        setCallback = nil
        newValueHandler = nil
    }
}
