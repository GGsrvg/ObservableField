//
//  ObservableDataSourceSubscribe.swift
//  ObservableField
//
//  Created by GGsrvg on 03.04.2022.
//

import Foundation

/**
 Protocol for subscribe 
 */
public protocol ObservableDataSourceSubscribe: AnyObject {
    func addCallback(_ callback: ObservableDataSourceDelegate)
    func removeCallback(_ callback: ObservableDataSourceDelegate)
}
