//
//  DiffTableViewController.swift
//  Sample
//
//  Created by Viktor on 16.06.2022.
//

import UIKit
import ObservableField

class DiffTableViewController: UIViewController {
    private var cancelContainer = CancelContainer()
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = DiffTableViewViewModel()
    
    var adapter: UITableViewClosureAdapter<ObservableArray<String>>!
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Sort",
                style: .plain,
                target: self,
                action: #selector(diffAction)
            )
        ]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        adapter = UITableViewClosureAdapter(
            tableView,
            observableDataSource: viewModel.observableArray,
            cellForRowHandler: { tableView, indexPath, row in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = row
                return cell
            },
            titleForHeaderSectionHandler: nil,
            titleForFooterSectionHandler: nil,
            numberOfSectionsHandler: nil,
            numberOfItemsInSectionHandler: nil
        )
        tableView.dataSource = adapter
        
        cancelContainer.activate([
            adapter,
        ])
    }
    
    @objc
    private func diffAction() {
        viewModel.setNew()
    }
}
