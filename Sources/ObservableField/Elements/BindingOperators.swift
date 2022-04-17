//
//  File.swift
//  
//
//  Created by Viktor on 17.04.2022.
//

import Foundation

// MARK: - Two Way Binding
infix operator <-> : DefaultPrecedence

public func <-> <TC, TV>(
    property: ControlProperty<TC, TV>,
    observable: ObservableField<TV>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromAll,
        property: property,
        observable: observable
    )
}

// MARK: - One Way Binding
// data can move only one way
infix operator <-- : DefaultPrecedence

public func <-- <TC, TV>(
    property: ControlProperty<TC, TV>,
    observable: ObservableField<TV>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromObservable,
        property: property,
        observable: observable
    )
}

infix operator --> : DefaultPrecedence

public func --> <TC, TV>(
    property: ControlProperty<TC, TV>,
    observable: ObservableField<TV>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromProperty,
        property: property,
        observable: observable
    )
}
