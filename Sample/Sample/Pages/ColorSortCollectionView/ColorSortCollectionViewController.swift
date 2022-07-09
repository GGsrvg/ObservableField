//
//  ColorSortCollectionViewController.swift
//  Sample
//
//  Created by Viktor on 05.07.2022.
//

import UIKit
import ObservableField

class ColorSortCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    let viewModel = ColorSortViewModel()
    
    var adapter: UICollectionViewClosureAdapter<ObservableArray<UIColor>>!
    
    deinit {
        print("deinit \(self.self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        adapter = UICollectionViewClosureAdapter(
            collectionView,
            observableDataSource: viewModel.observableArray,
            cellForRowHandler: { collectionView, indexPath, row in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = row
                return cell
            },
            viewForSupplementaryElementOfKindHandler: nil,
            numberOfSectionsHandler: nil,
            numberOfItemsInSectionHandler: nil
        )
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = adapter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.sort()
    }
}
