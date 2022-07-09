//
//  SearchViewController.swift
//  Sample
//
//  Created by Viktor on 17.04.2022.
//

import UIKit
import ObservableField

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cancelContainer = CancelContainer()
    
    let viewModel = SearchViewModel()
    
    var adapter: UITableViewClosureAdapter<ObservableArray<String>>!
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            searchBar.searchTextField.observableText --> viewModel.observableSearch,
            adapter,
        ])
    }
}
