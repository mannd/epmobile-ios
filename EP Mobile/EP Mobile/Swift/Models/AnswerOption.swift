//
//  AnswerOption.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct AnswerOption: Hashable, Codable, Comparable {
    static func < (lhs: AnswerOption, rhs: AnswerOption) -> Bool {
        return lhs.id < rhs.id
    }

    let id: String     // e.g., "yes", "no"
    let label: String  // e.g., "Yes", "No"

    static let yesNo: [AnswerOption] = [
        .init(id: "yes", label: "Yes"),
        .init(id: "no", label: "No"),
    ]
}

