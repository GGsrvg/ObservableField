//
//  UISegmentedControl.swift
//  
//
//  Created by GGsrvg on 09.06.2022.
//

import UIKit

public extension UISegmentedControl {
    var selectedSegmentedIndexControlProperty: ControlProperty<UISegmentedControl, Int> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { segmentedControl in
                segmentedControl.selectedSegmentIndex
            },
            set: { segmentedControl, selectedSegmentIndex in
                segmentedControl.selectedSegmentIndex = selectedSegmentIndex
            }
        )
    }
}
