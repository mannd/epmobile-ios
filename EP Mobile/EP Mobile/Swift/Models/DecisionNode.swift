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

struct MultipleDecisionNode : Codable {
    var question: String?
    var branches: [AnswerOption.RawValue: MultipleDecisionNode]?
    // Note: the JSON decoder cna't handle [AnswerOption: MutlipeDecisionNode], though it should.
    // See https://developer.apple.com/forums/thread/747665
    var result: String?

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
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context.debugDescription)")
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
            return nil
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription)")
            return nil
        } catch {
            print("Failed to decode decision tree: \(error.localizedDescription)")
            return nil
        }
    }
}
