//
//  Cancellable+Store.swift
//
//
//  Created by GGsrvg on 02.12.2023.
//

import Combine

extension AnyCancellable {
    public func store(in cancelContainer: CancelContainer) {
        cancelContainer.activate(self)
    }
}
