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

### You can link objects in three ways:
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
    // linking object
    cancelContainer.activate([
        searchBar.searchTextField.observableText --> viewModel.observableSearch
    ])
}

```
