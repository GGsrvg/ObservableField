//
//  UITextField.swift
//  
//
//  Created by GGsrvg on 10.04.2022.
//

import UIKit

public extension UITextField {
    var observableText: ControlProperty<UITextField, String?> {
        ControlProperty(
            control: self,
            with: [.editingChanged],
            get: { textField in
                textField.text
            },
            set: { textField, text in
                textField.text = text
            }
        )
    }
}
