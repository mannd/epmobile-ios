//
//  TupleEquitable.swift
//  EP Mobile
//
//  Created by David Mann on 10/3/26.
//  Copyright © 2026 EP Studios. All rights reserved.
//

import Foundation

/// An Equatable container that can hold a dynamic "pack" of different Equatable values and is itself Equatable.
struct Observe<each T: Equatable>: Equatable {
    private let values: (repeat each T)

    init(_ values: repeat each T) {
        self.values = (repeat each values)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        // Loops through every item in the pack and evaluates them
        for isEqual in repeat each lhs.values == each rhs.values {
            guard isEqual else { return false }
        }
        return true
    }
}

