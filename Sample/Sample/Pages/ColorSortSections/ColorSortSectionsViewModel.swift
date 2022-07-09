//
//  ColorSortSectionsViewModel.swift
//  Sample
//
//  Created by Viktor on 08.07.2022.
//

import ObservableField
import UIKit

class ColorSortSectionsViewModel {
    typealias SI = SectionItem<String, UIColor, Optional<Never>>
    
    let colorsDataSource = ObservableDataSource<SI>()
    
    private let red1 = UIColor(rgb: 0xff0000)
    private let red2 = UIColor(rgb: 0xff1e00)
    private let red3 = UIColor(rgb: 0xff3300)
    private let red4 = UIColor(rgb: 0xff4800)
    
    private let yellow1 = UIColor(rgb: 0xFFD900)
    private let yellow2 = UIColor(rgb: 0xFFEF00)
    private let yellow3 = UIColor(rgb: 0xEDFF00)
    private let yellow4 = UIColor(rgb: 0xDAFF00)
    
    private let green1 = UIColor(rgb: 0x54FF00)
    private let green2 = UIColor(rgb: 0x1BFF00)
    private let green3 = UIColor(rgb: 0x00FF11)
    private let green4 = UIColor(rgb: 0x00FF2F)
    
    private let blue1 = UIColor(rgb: 0x00FDFF)
    private let blue2 = UIColor(rgb: 0x00C5FF)
    private let blue3 = UIColor(rgb: 0x007EFF)
    private let blue4 = UIColor(rgb: 0x002FFF)
    
    private lazy var original = [
        SI(
            header: "Red",
            rows: [
                self.red1,
                self.yellow1,
                self.green1,
                self.blue1,
            ].shuffled(),
            footer: nil
        ),
        SI(
            header: "Yellow",
            rows: [
                self.red2,
                self.yellow2,
                self.green2,
                self.blue3,
            ].shuffled(),
            footer: nil
        ),
        SI(
            header: "Green",
            rows: [
                self.red3,
                self.yellow3,
                self.green3,
                self.blue3,
            ].shuffled(),
            footer: nil
        ),
        SI(
            header: "Blue",
            rows: [
                self.red4,
                self.yellow4,
                self.green4,
                self.blue4,
            ].shuffled(),
            footer: nil
        ),
    ].shuffled()
    
    private lazy var sorted = [
        SI(
            header: "Red",
            rows: [
                self.red1,
                self.red2,
                self.red3,
                self.red4,
            ],
            footer: nil
        ),
        SI(
            header: "Yellow",
            rows: [
                self.yellow1,
                self.yellow2,
                self.yellow3,
                self.yellow4,
            ],
            footer: nil
        ),
        SI(
            header: "Green",
            rows: [
                self.green1,
                self.green2,
                self.green3,
                self.green4,
            ],
            footer: nil
        ),
        SI(
            header: "Blue",
            rows: [
                self.blue1,
                self.blue2,
                self.blue3,
                self.blue4,
            ],
            footer: nil
        ),
    ]
    
    init() {
        colorsDataSource.differ = DefaultDifferDataSource()
        colorsDataSource.differArray = DefaultDifferArray()
        colorsDataSource.set(original)
    }
    
    func sort() {
        colorsDataSource.setAndUpdateDiffable(self.sorted)
    }
}
