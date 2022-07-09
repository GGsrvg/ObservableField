//
//  ColorSortViewModel.swift
//  Sample
//
//  Created by Viktor on 09.04.2022.
//

import UIKit
import ObservableField

class ColorSortViewModel {
    
    private var colors: [UIColor] = [
        .init(rgb: 0xff0000),
        .init(rgb: 0xff4000),
        .init(rgb: 0xff8000),
        .init(rgb: 0xffbf00),
        .init(rgb: 0xffff00),
        .init(rgb: 0xbfff00),
        .init(rgb: 0x80ff00),
        .init(rgb: 0x40ff00),
        .init(rgb: 0x00ff00),
        .init(rgb: 0x00ff40),
        .init(rgb: 0x00ff80),
        .init(rgb: 0x00ffbf),
        .init(rgb: 0x00ffff),
        .init(rgb: 0x00bfff),
        .init(rgb: 0x0080ff),
        .init(rgb: 0x0040ff),
        .init(rgb: 0x0000ff),
        .init(rgb: 0x4000ff),
        .init(rgb: 0x8000ff),
        .init(rgb: 0xbf00ff),
        .init(rgb: 0xff00ff),
        .init(rgb: 0xff00bf),
        .init(rgb: 0xff0080),
        .init(rgb: 0xff0040),
    ]
    
    let observableArray = ObservableArray<UIColor>()
    
    init() {
        self.colors = self.colors.shuffled()
        self.observableArray.differ = DefaultDifferArray()
        self.observableArray.set(colors)
    }
    
    deinit {
        print("deinit \(self.self)")
    }
    
    func sort() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
//            self.observableArray.buildChanges {
//                for i in 0..<(self.observableArray.count) {
//                    for j in 1..<(self.observableArray.count - i) {
//                        let jValue = self.observableArray[j]
//                        let temp = self.observableArray[j - 1]
//
//                        if jValue.hue < temp.hue {
//                            self.observableArray.replaceRow(jValue, at: j - 1)
//                            self.observableArray.replaceRow(temp, at: j)
//                        }
//                    }
//                }
//            }
//        }
        
        // create ordered array
        var orderedArray = self.observableArray.array
        for i in 0..<(orderedArray.count) {
            for j in 1..<(orderedArray.count - i) {
                let jValue = orderedArray[j]
                let temp = orderedArray[j - 1]
                
                if jValue.hue < temp.hue {
                    orderedArray[j - 1] = jValue
                    orderedArray[j] = temp                }
            }
        }
        // update
        self.observableArray.setAndUpdateDiffable(orderedArray)
    }
}
