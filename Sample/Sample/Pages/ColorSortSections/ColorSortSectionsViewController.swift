//
//  ColorSortSectionsViewController.swift
//  Sample
//
//  Created by Viktor on 08.07.2022.
//

import UIKit
import ObservableField

class ColorSortSectionsViewController: UIViewController {
    typealias SI = SectionItem<String, UIColor, Optional<Never>>
    typealias ODS = ObservableDataSource<SI>
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    let viewModel = ColorSortSectionsViewModel()
    
    var adapter: UICollectionViewClosureAdapter<ODS>!
    
    deinit {
        print("deinit \(self.self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        columnLayout.headerReferenceSize = CGSize(width: 0, height: 32)
        columnLayout.sectionHeadersPinToVisibleBounds = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            UINib(nibName: "TitleCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        adapter = UICollectionViewClosureAdapter(
            collectionView,
            observableDataSource: viewModel.colorsDataSource,
            cellForRowHandler: { collectionView, indexPath, row in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = row
                return cell
            },
            viewForSupplementaryElementOfKindHandler: { [weak self] collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let header = self?.viewModel.colorsDataSource[indexPath.section].header
                    let view = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "header",
                        for: indexPath
                    ) as! TitleCollectionReusableView
                    view.label?.text = header
                    return view
                default:
                    return UICollectionReusableView()
                }
            },
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
