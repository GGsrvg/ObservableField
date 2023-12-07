//
//  UIDatePicker.swift
//  
//
//  Created by GGsrvg on 09.06.2022.
//

import UIKit

public extension UIDatePicker {
    var dateControlProperty: ControlProperty<UIDatePicker, Date> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { datePicker in
                datePicker.date
            },
            set: { datePicker, date in
                datePicker.date = date
            }
        )
    }
}
