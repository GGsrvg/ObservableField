//
//  Handler.swift
//  
//
//  Created by GGsrvg on 14.11.2023.
//

import Foundation

public class Handler<V: Equatable> {
    public typealias ValueHandler = (V) -> Void
    
    let name: String
    private let valueHandler: ValueHandler
    
    public init(
        name: String = UUID().uuidString,
        valueHandler: @escaping ValueHandler
    ) {
        self.name = name
        self.valueHandler = valueHandler
    }
    
    public func call(value: V) {
        valueHandler(value)
    }
}
