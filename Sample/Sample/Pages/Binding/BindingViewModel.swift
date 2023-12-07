//
//  BindingViewModel.swift
//  Sample
//
//  Created by GGsrvg on 03.12.2023.
//

import ObservableField
import Combine
import UIKit
import Foundation

final class BindingViewModel {
    
    
    let textSubject = CurrentValueSubject<String?, Error>(nil)
    let isOnSubject = CurrentValueSubject<Bool, Error>(true)
    let segmentedSubject = CurrentValueSubject<Int, Error>(0)
    let dateSubject = CurrentValueSubject<Date, Error>(Date())
    let sliderSubject = CurrentValueSubject<Float, Error>(0)
    let colorSubject = CurrentValueSubject<UIColor?, Error>(nil)
    let pageSubject = CurrentValueSubject<Int, Error>(0)
    
    let resultSubject = CurrentValueSubject<String?, Error>(nil)
    
    private let cancelContainer = CancelContainer()
    
    init() {
        cancelContainer.activate([
            textSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            isOnSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            segmentedSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            dateSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            sliderSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            colorSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
            pageSubject.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self else { return }
                self.updateResult()
            }),
        ])
    }
    
    deinit {
        print("Deinit: \(#fileID)")
    }
    
    private func updateResult() {
        let text = """
        Text: \(textSubject.value ?? "NONE")
        Switch: \(isOnSubject.value)
        Segmented: \(segmentedSubject.value)
        Date: \(dateSubject.value)
        Slider: \(sliderSubject.value)
        Color: \(colorSubject.value?.htmlRGBaColor ?? "NONE")
        Page: \(pageSubject.value)
        """
        
        resultSubject.send(text)
    }
}

// https://stackoverflow.com/questions/36341358/how-to-convert-uicolor-to-string-and-string-to-uicolor-using-swift
fileprivate extension UIColor {
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    
    var htmlRGBColor: String {
        return String(
            format: "#%02x%02x%02x",
            Int(rgbComponents.red * 255),
            Int(rgbComponents.green * 255),
            Int(rgbComponents.blue * 255)
        )
    }
    var htmlRGBaColor: String {
        return String(
            format: "#%02x%02x%02x%02x",
            Int(rgbComponents.red * 255),
            Int(rgbComponents.green * 255),
            Int(rgbComponents.blue * 255),
            Int(rgbComponents.alpha * 255)
        )
    }
}
