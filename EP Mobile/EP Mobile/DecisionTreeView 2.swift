//
//  DecisionTreeView 2.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

struct DecisionTreeView2: View {
    @State private var nodeStack: [MultipleDecisionNode] = []
    @State private var currentNode: MultipleDecisionNode
    @State private var result: String?
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    init(rootNode: MultipleDecisionNode) {
        _currentNode = State(initialValue: rootNode)
    }

    var body: some View {
        VStack {
            Text(currentNode.question!)
                .font(.title)
                .padding()

            if let note = currentNode.note {
                Text(note)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            if let result = result {
                Text(result)
                    .font(.headline)
                    .padding()
            } else {
                    LazyVGrid(columns: columns, spacing: 16) {

                        ForEach(AnswerOption.allCases, id: \.self) { option in
                            if let _ = currentNode.branches?[option.rawValue] {
                                Button(option.label) {
                                    moveToNextNode(forAnswer: option.rawValue)
                                }.roundedButton()

                            }
                        }
                        if !nodeStack.isEmpty {
                            Button("Back") {
                                currentNode = nodeStack.removeLast()
                            }
                            .roundedButton()
                        }
                }
            }
        }
        .padding()
    }

    func moveToNextNode(forAnswer answer: String) {
        if let nextNode = currentNode.branches![answer] {
            if let result = nextNode.result {
                self.result = result
            } else {
                nodeStack.append(currentNode)
                currentNode = nextNode
            }
        }
    }
}

struct DecisionTreeViews_Previews: PreviewProvider {
    static var previews: some View {
        if let node = MultipleDecisionNode.loadDecisionTree(from: "test") {
            DecisionTreeView2(rootNode: node)
        }

        //        let dog = MultipleDecisionNode(result: "You should get a dog.")
//        let cat = MultipleDecisionNode(result: "You should get a cat.")
//        let fish = MultipleDecisionNode(result: "You should get a fish.")
//        let likesFur = MultipleDecisionNode(question: "Do you like fur?", branches: [AnswerOption.yes.rawValue: dog, AnswerOption.no.rawValue: fish])
//        let wantsPet = MultipleDecisionNode(question: "Do you want a pet?", branches: [AnswerOption.yes.rawValue: likesFur, AnswerOption.no.rawValue: cat])

//        DecisionTreeView2(rootNode: wantsPet)
    }
}


