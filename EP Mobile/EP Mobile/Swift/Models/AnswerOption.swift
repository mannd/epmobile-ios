//
//  AnswerOption.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

//struct AnswerOption: Hashable, Codable, Comparable {
//    static func < (lhs: AnswerOption, rhs: AnswerOption) -> Bool {
//        return lhs.id < rhs.id
//    }
//
//    let id: String     // e.g., "yes", "no"
//    let label: String  // e.g., "Yes", "No"
//
//    static let yesNo: [AnswerOption] = [
//        .init(id: "yes", label: "Yes"),
//        .init(id: "no", label: "No"),
//    ]
//}

enum AnswerOption: String, Codable, CaseIterable, Comparable {
    static func < (lhs: AnswerOption, rhs: AnswerOption) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    case yes, no, maybe, none
    // Add more as needed

    var label: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .maybe: return "Maybe"
        case .none: return "None"
        }
    }

    // Note: get enum from rawValue
    static func value(rawValue: String) -> AnswerOption {
        if let option = AnswerOption(rawValue: rawValue) {
            return option
        } else {
            return .none
        }
    }
}

