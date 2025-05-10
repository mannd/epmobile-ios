//
//  DecisionNode.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

class DecisionNode : ObservableObject, Decodable {
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

extension DecisionNode {
    static func loadDecisionTree(from filename: String) -> DecisionNode? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Missing file: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let tree = try JSONDecoder().decode(DecisionNode.self, from: data)
            return tree
        } catch {
            print("Failed to decode decision tree: \(error)")
            return nil
        }
    }
}

class MultipleDecisionNode : ObservableObject, Decodable {
    var question: String
    var branches: [AnswerOption: MultipleDecisionNode]  // Dictionary to store branches based on answers
    var result: String?
    var note: String?  // optional intermediate result

    init(question: String, branches: [AnswerOption: MultipleDecisionNode] = [:], note: String? = nil) {
        self.question = question
        self.branches = branches
        self.result = nil
        self.note = note
    }

    // Convenience initializer for leaf nodes (where result is known)
    init(result: String, note: String? = nil) {
        self.question = ""
        self.branches = [:]
        self.result = result
        self.note = note
    }

    var isLeaf: Bool {
        return result != nil
    }
}

extension MultipleDecisionNode {
    static func loadDecisionTree(from filename: String) -> MultipleDecisionNode? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Missing file: \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let tree = try JSONDecoder().decode(MultipleDecisionNode.self, from: data)
            return tree
        } catch {
            print("Failed to decode decision tree: \(error)")
            return nil
        }
    }
}
