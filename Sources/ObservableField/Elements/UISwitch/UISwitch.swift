//
//  UISwitch.swift
//  
//
//  Created by GGsrvg on 17.04.2022.
//

import UIKit

public extension UISwitch {
    var isOnControlProperty: ControlProperty<UISwitch, Bool> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { switchControl in
                switchControl.isOn
            },
            set: { switchControl, isOn in
                switchControl.isOn = isOn
            }
        )
    }
}
