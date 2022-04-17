//
//  UISwitch.swift
//  
//
//  Created by Viktor on 17.04.2022.
//

import UIKit

extension UISwitch {
    var observableIsOn: ControlProperty<UISwitch, Bool> {
        ControlProperty(
            control: self,
            with: [.editingChanged],
            get: { switchControl in
                switchControl.isOn
            },
            set: { switchControl, isOn in
                switchControl.isOn = isOn
            }
        )
    }
}
