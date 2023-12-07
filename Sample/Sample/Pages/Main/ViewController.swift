//
//  ViewController.swift
//  Sample
//
//  Created by Viktor on 09.04.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [SampleItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationController = navigationController else { return }
        
        items = [
            SampleItem(
                name: "Color Sort",
                action: {
                    let vc = ColorSortViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
            SampleItem(
                name: "Color Sort With UICollectionVIew",
                action: {
                    let vc = ColorSortCollectionViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
            SampleItem(
                name: "Color Sort Sections",
                action: {
                    let vc = ColorSortSectionsViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
            SampleItem(
                name: "Search",
                action: {
                    let vc = SearchViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
            SampleItem(
                name: "Table Diff",
                action: {
                    let vc = DiffTableViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
            SampleItem(
                name: "Binding",
                action: {
                    let vc = BindingViewController()
                    navigationController.pushViewController(vc, animated: true)
                }
            ),
        ]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = items[indexPath.row]
        
        cell.textLabel?.text = model.name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = items[indexPath.row]
        model.action()
    }
}
