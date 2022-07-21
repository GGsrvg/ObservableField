# ObservableField

Field binding for MVVM

## TODO:
- [X] Track buildChanges in adapter and use performBatchUpdates(_:completion:)
- [x] Differ for lists
- [ ] Support GRDB, observe table
- [ ] Support CoreData, observe table

## How to use?

### `Cancelable` and `CancelContainer`.

`Cancelable` is a basic protocol that helps clear object references.
`CancelContainer` is the mechanism that stores and notifies `Cancelable` objects. Calls `Cancelable.cancel` during deincilization to clear references.

### `ControlProperty` and `ControlAction`.

`ControlProperty` is an object for tracking changes and inserting new values.
`ControlAction` is an object for tracking actions.

### You can bind objects in three ways:
- -->: Data is only sent from the View.
- <--: Data is only sent from the code.
- <->: Data can be sent from View and code.

ViewModel
```
let observableSearch = ObservableField<String?>(nil)
```

ViewController
```
@IBOutlet weak var searchBar: UISearchBar!
    
override func viewDidLoad() {
    super.viewDidLoad()
    // binding object
    cancelContainer.activate([
        searchBar.searchTextField.observableText --> viewModel.observableSearch
    ])
}

```

### Bind UITableView and UICollectionView

ViewModel
```
let observableArray = ObservableArray<String>()
```

ViewController
```
@IBOutlet weak var tableView: UITableView!
    
override func viewDidLoad() {
    super.viewDidLoad()
    // init adapter for UITableView 
    // Pass a reference to `UITableView`
    // Pass the data source
    // And set the display of the cell.
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
    // Finally, pass the adapter to `CancelContainer` to clean up links automatically.
    cancelContainer.activate([
        adapter
    ])
}

```
