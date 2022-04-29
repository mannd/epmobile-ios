//
//  IntervalRateConversion.swift
//  EP Mobile
//
//  Created by David Mann on 4/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum IntervalRateConversion {
    static func convert(value: Int) -> String? {
        guard value > 0 else { return nil }
        return String(Int(round(60_000.0 / Double(value))))
    }
}
