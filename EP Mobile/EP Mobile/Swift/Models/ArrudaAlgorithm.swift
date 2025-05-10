//
//  ArrudaAlgorithm.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct ArrudaAlgorithm : Algorithm {
    let name: String = "Arruda Algorithm"

    let options: [AnswerOption] = AnswerOption.yesNo
    let rootNode: MultipleDecisionNode

    init() {
        self.rootNode = MultipleDecisionNode.loadDecisionTree(from: "arruda-algorithm") ?? MultipleDecisionNode(result: "Error")
    }
}

