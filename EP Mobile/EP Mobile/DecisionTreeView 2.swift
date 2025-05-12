////
////  DecisionTreeView 2.swift
////  EP Mobile
////
////  Created by David Mann on 5/10/25.
////  Copyright © 2025 EP Studios. All rights reserved.
////
//
//import SwiftUI
//
//struct DecisionTreeView2: View {
//    @State private var currentNode: MultipleDecisionNode
//    @State private var result: String?
//
//    init(rootNode: MultipleDecisionNode) {
//        _currentNode = State(initialValue: rootNode)
//    }
//
//    var body: some View {
//        VStack {
//            Text(currentNode.question)
//                .font(.title)
//                .padding()
//
//            if let result = result {
//                Text(result)
//                    .font(.headline)
//                    .padding()
//            } else {
//                ForEach(currentNode.branches!.keys.sorted(), id: \.self) { answer in
//                    Button(answer.label) {
//                        moveToNextNode(forAnswer: answer)
//                    }
//                    .padding()
//                }
//            }
//        }
//        .padding()
//    }
//
//    func moveToNextNode(forAnswer answer: AnswerOption) {
//        if let nextNode = currentNode.branches![answer] {
//            if let result = nextNode.result {
//                self.result = result
//            } else {
//                currentNode = nextNode
//            }
//        }
//    }
//}
//
//
//struct DecisionTreeViews_Previews: PreviewProvider {
//    static var previews: some View {
//        if let node = MultipleDecisionNode.loadDecisionTree(from: "arruda-algoirhtm") {
//            DecisionTreeView2(rootNode: node)
//        }
////        let dog = MultipleDecisionNode(result: "You should get a dog.")
////        let cat = MultipleDecisionNode(result: "You should get a cat.")
////        let fish = MultipleDecisionNode(result: "You should get a fish.")
////        let likesFur = MultipleDecisionNode(question: "Do you like fur?", branches: [AnswerOption.yes: dog, AnswerOption.no: fish])
////        let wantsPet = MultipleDecisionNode(question: "Do you want a pet?", branches: [AnswerOption.yes: likesFur, AnswerOption.no: cat])
////
//    }
//}
//
//
