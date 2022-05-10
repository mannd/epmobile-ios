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
        return String(Int(round(convert(value: Double(value)))))
    }

    static func convert(value: Double) -> Double {
        return 60_000.0 / value
    }

    static func secsToMsec(_ secs: Double) -> Double {
        return secs * 1000.0
    }

    static func msecToSecs(_ msecs: Double) -> Double {
        return msecs / 1000.0
    }
}
