//
//  Cancelable.swift
//  
//
//  Created by GGsrvg on 10.04.2022.
//

import Foundation

public protocol Cancelable: AnyObject {
    var isCanceled: Bool { get }
    
    func cancel()
}
