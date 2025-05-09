//
//  DecisionNode.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

class DecisionNode : ObservableObject {
    var question: String?
    var trueBranch: DecisionNode?
    var falseBranch: DecisionNode?
    var result: String?
    var note: String?  // optional intermediate result

    // internal node
    init(question: String, trueBranch: DecisionNode, falseBranch: DecisionNode, note: String? = nil) {
        self.question = question
        self.trueBranch = trueBranch
        self.falseBranch = falseBranch
        self.note = note
    }

    // leaf node
    init(result: String) {
        self.result = result
    }

    var isLeaf: Bool {
        return result != nil
    }
}


