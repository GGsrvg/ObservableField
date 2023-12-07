//
//  UIColorWell.swift
//  
//
//  Created by GGsrvg on 03.12.2023.
//

import UIKit

@available(iOS 14.0, *)
public extension UIColorWell {
    var colorControlProperty: ControlProperty<UIColorWell, UIColor?> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.selectedColor
            },
            set: { control, value in
                control.selectedColor = value
            }
        )
    }
}
