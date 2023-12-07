//
//  UISlider.swift
//  
//
//  Created by GGsrvg on 03.12.2023.
//

import UIKit

public extension UISlider {
    var minimumValueControlProperty: ControlProperty<UISlider, Float> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.minimumValue
            },
            set: { control, value in
                control.minimumValue = value
            }
        )
    }
    
    var valueControlProperty: ControlProperty<UISlider, Float> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.value
            },
            set: { control, value in
                control.value = value
            }
        )
    }
    
    var maximumValueControlProperty: ControlProperty<UISlider, Float> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.maximumValue
            },
            set: { control, value in
                control.maximumValue = value
            }
        )
    }
}
