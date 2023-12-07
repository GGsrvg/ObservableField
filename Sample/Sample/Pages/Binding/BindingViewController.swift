//
//  BindingViewController.swift
//  Sample
//
//  Created by GGsrvg on 03.12.2023.
//

import UIKit
import ObservableField

class BindingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var isOnSwitch: UISwitch!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorWell: UIColorWell!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var label: UILabel!
    
    private let viewModel = BindingViewModel()
    private let cancelContainer = CancelContainer()
    
    deinit {
        print("Deinit: \(#fileID)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelContainer.activate([
            textField.textControlProperty <-> viewModel.textSubject,
            isOnSwitch.isOnControlProperty <-> viewModel.isOnSubject,
            segmented.selectedSegmentedIndexControlProperty <-> viewModel.segmentedSubject,
            datePicker.dateControlProperty <-> viewModel.dateSubject,
            slider.valueControlProperty <-> viewModel.sliderSubject,
            colorWell.colorControlProperty <-> viewModel.colorSubject,
            pageControl.currentPageControlProperty <-> viewModel.pageSubject,
            
            viewModel.resultSubject.sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.label.text = value
                })
        ])
    }
}
