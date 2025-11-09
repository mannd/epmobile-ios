//
//  DecisionNode.swift
//  EP Designer
//
//  Created by David Mann on 9/12/25.
//

import Foundation

struct DecisionNode: Codable, Identifiable, Hashable {
    let id: String
    var label: String // "" for root or leaf, or the answer text from parent
    var question: String?
    var branches: [DecisionNode]?
    var result: String?
    var note: String?
    var tag: String?

    var isLeaf: Bool { result != nil }

    static let rootNodeId: String = "node-root"

    // MARK: - Initializer
    init(id: String = UUID().uuidString,
         label: String = "",
         question: String? = nil,
         branches: [DecisionNode]? = nil,
         result: String? = nil,
         note: String? = nil,
         tag: String? = nil) {
        self.id = id
        self.label = label
        self.question = question
        self.branches = branches
        self.result = result
        self.note = note
        self.tag = tag
    }

    static func new() -> DecisionNode {
        DecisionNode(id: Self.rootNodeId, label: "Root", question: "Add first question here.")
    }

    // Hash / equality based ONLY on id (stable & cheap)
    static func == (lhs: DecisionNode, rhs: DecisionNode) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - JSON Persistence
extension DecisionNode {
    /// Saves the node (and its nested tree) to a file at the specified URL
    func save(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        try data.write(to: url)
    }

    /// Loads a nested tree from a file at the specified URL
    static func load(from url: URL) throws -> DecisionNode {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(DecisionNode.self, from: data)
    }
}
