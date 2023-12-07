//
//  UIPageControl.swift
//  
//
//  Created by GGsrvg on 03.12.2023.
//

import UIKit

public extension UIPageControl {
    var currentPageControlProperty: ControlProperty<UIPageControl, Int> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.currentPage
            },
            set: { control, value in
                control.currentPage = value
                print("Curr : \(control.currentPage)")
            }
        )
    }
    
    var numberPageControlProperty: ControlProperty<UIPageControl, Int> {
        ControlProperty(
            control: self,
            with: [.valueChanged],
            get: { control in
                control.numberOfPages
            },
            set: { control, value in
                control.numberOfPages = value
            }
        )
    }
}
