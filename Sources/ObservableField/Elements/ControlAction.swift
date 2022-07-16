//
//  ControlAction.swift
//  
//
//  Created by GGsrvg on 15.07.2022.
//

import UIKit

open class ControlAction<TC>: NSObject where TC: UIControl {
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
              let action = action
        else { return }
        
        action(control)
    }
}

extension ControlAction: Cancelable {
    public var isCanceled: Bool {
        get { _isCanceled }
    }
    
    public func cancel() {
        defer {
            _isCanceled = true
        }
        
        control?.removeTarget(self, action: selector, for: self.events)
        control = nil
        action = nil
    }
}
