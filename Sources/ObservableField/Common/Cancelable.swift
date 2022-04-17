//
//  Cancelable.swift
//  
//
//  Created by Viktor on 10.04.2022.
//

import Foundation

public protocol Cancelable {
    var isCanceled: Bool { get }
    
    func cancel()
}
