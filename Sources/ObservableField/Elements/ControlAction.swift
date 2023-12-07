//
//  ControlAction.swift
//  
//
//  Created by GGsrvg on 15.07.2022.
//

import UIKit
import Combine

// WARNING: dont remove NSObject
open class ControlAction<TC>: NSObject, Cancellable where TC: UIControl {
    public typealias Action = (TC) -> Void
    
    let selector = #selector(eventHandler)
    
    weak var control: TC?
    var events: UIControl.Event
    var action: Action?
    
    private var _isCanceled: Bool = false
    
    public init(
        control: TC,
        with events: UIControl.Event,
        action: @escaping Action
    ) {
        self.control = control
        self.events = events
        self.action = action
        
        super.init()
        
        control.addTarget(self, action: selector, for: events)
    }
    
    @objc private func eventHandler() {
        guard let control = control,
              let action = action,
              !isCanceled
        else { return }
        
        action(control)
    }
    
    public private(set) var isCanceled: Bool = false
    
    public func cancel() {
        if (isCanceled) {
            return
        }
        isCanceled = true
        
        control?.removeTarget(self, action: selector, for: self.events)
        control = nil
        action = nil
    }
}
