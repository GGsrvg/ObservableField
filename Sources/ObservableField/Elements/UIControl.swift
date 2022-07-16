//
//  File.swift
//  
//
//  Created by GGsrvg on 15.07.2022.
//

import UIKit

public protocol WrappleSetAction {
}

public extension WrappleSetAction where Self : UIControl {
    func addAction(
        events: UIControl.Event,
        action: @escaping ControlAction<Self>.Action
    ) -> ControlAction<Self> {
        return ControlAction<Self>(
            control: self,
            with: events,
            action: action
        )
    }
}

extension UIControl: WrappleSetAction {
}
