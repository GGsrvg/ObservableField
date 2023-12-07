//
//  BindingOperators.swift
//  
//
//  Created by GGsrvg on 17.04.2022.
//

import Combine

// MARK: - Two Way Binding
infix operator <-> : DefaultPrecedence

public func <-> <TC, TV>(
    property: ControlProperty<TC, TV>,
    subject: any Subject<TV, Error>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromAll,
        property: property,
        subject: subject
    )
}

// MARK: - One Way Binding
// data can move only one way
infix operator <-- : DefaultPrecedence

public func <-- <TC, TV>(
    property: ControlProperty<TC, TV>,
    subject: any Subject<TV, Error>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromSubject,
        property: property,
        subject: subject
    )
}

infix operator --> : DefaultPrecedence

public func --> <TC, TV>(
    property: ControlProperty<TC, TV>,
    subject: any Subject<TV, Error>
) -> Binding<TC, TV> {
    return Binding(
        type: .fromProperty,
        property: property,
        subject: subject
    )
}
