//
//  ColorSortViewController.swift
//  Sample
//
//  Created by Viktor on 09.04.2022.
//

import UIKit
import ObservableField

class ColorSortViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ColorSortViewModel()
    
    var adapter: UITableViewClosureAdapter<ObservableArray<UIColor>>!
    
    deinit {
        print("deinit \(self.self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 28
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        adapter = UITableViewClosureAdapter(
            tableView,
            observableDataSource: viewModel.observableArray,
            cellForRowHandler: { tableView, indexPath, row in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.backgroundColor = row
                return cell
            },
            titleForHeaderSectionHandler: nil,
            titleForFooterSectionHandler: nil,
            numberOfSectionsHandler: nil,
            numberOfItemsInSectionHandler: nil
        )
        tableView.dataSource = adapter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.sort()
    }
}
