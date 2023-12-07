//
//  UITextField.swift
//  
//
//  Created by GGsrvg on 10.04.2022.
//

import UIKit

public extension UITextField {
    var textControlProperty: ControlProperty<UITextField, String?> {
        return createTextControlProperty(with: [.editingChanged])
    }
    
    func createTextControlProperty(with events: UIControl.Event) -> ControlProperty<UITextField, String?> {
        return ControlProperty(
            control: self,
            with: events,
            get: { textField in
                textField.text
            },
            set: { textField, text in
                textField.text = text
            }
        )
    }
}
