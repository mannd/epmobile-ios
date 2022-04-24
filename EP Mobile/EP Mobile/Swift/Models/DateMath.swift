//
//  DateMath.swift
//  EP Mobile
//
//  Created by David Mann on 4/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum DateMath {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func addDays(startingDate: Date, days: Int, subtractDays: Bool) -> String {
        var dayDifference: Double  = Double(days)
        if subtractDays {
            dayDifference = -dayDifference
        }
        let interval: TimeInterval = dayDifference * 24 * 60 * 60
        let resultDate = startingDate.addingTimeInterval(interval)
        let formattedDate = dateFormatter.string(from: resultDate)
        return formattedDate
    }
}

