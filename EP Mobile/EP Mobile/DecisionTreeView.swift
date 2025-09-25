//
//  DecisionTreeView.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//


import SwiftUI

struct DecisionTreeView: View {
    let root: DecisionNode
    @State private var currentNode: DecisionNode
    @State private var nodeStack: [DecisionNode] = []
    @State private var result: String?
    @State private var showResult = false
    @State private var resultText = ""


    init(root: DecisionNode) {
        self.root = root
        _currentNode = State(wrappedValue: root)
    }

    var body: some View {
        VStack(spacing: 20) {
            if currentNode.isLeaf {
                Color.clear.onAppear() {
                    showResult = true
                    resultText = currentNode.result ?? "No Result"
                }
            } else {
                Text(currentNode.question!)
                    .font(.title)
                    .padding()

                HStack {
                    Button("Yes") {
                        moveToNextNode(isYes: true)
                    }
                    .padding()
                    // TODO: playing with button styling
                    .font(.title)
//                    .background(Color.green)
//                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
//                    .buttonBorderShape(.capsule)
//                    .cornerRadius(8)

                    Button("No") {
                        moveToNextNode(isYes: false)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    if !nodeStack.isEmpty {
                        Button("Back") {
                            currentNode = nodeStack.removeLast()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .alert("Result", isPresented: $showResult, actions: {
                    Button("OK") {
                        // Reset to the beginning after result
                        currentNode = root
                        nodeStack.removeAll()
                    }
                }, message: {
                    Text(resultText)
                })
            }
        }
    }

    private func moveToNextNode(isYes: Bool) {
        if isYes, let trueBranch = currentNode.trueBranch {
            nodeStack.append(currentNode)
            currentNode = trueBranch
        } else if !isYes, let falseBranch = currentNode.falseBranch {
            nodeStack.append(currentNode)
            currentNode = falseBranch
        }
        // If it's a leaf node, set the result
        if currentNode.isLeaf {
            result = currentNode.result
        }
    }
}

struct ContentView: View {
    var body: some View {
        // Example decision tree
        let dog = DecisionNode(result: "You should get a dog.")
        let cat = DecisionNode(result: "You should get a cat.")
        let fish = DecisionNode(result: "You should get a fish.")

        let likesFur = DecisionNode(question: "Do you like fur?", trueBranch: dog, falseBranch: fish)
        let wantsPet = DecisionNode(question: "Do you want a pet?", trueBranch: likesFur, falseBranch: cat)

        DecisionTreeView(root: wantsPet)
    }
}

struct DecisionTreeView_Previews: PreviewProvider {
    static var previews: some View {
//        let node = DecisionNode.loadDecisionTree(from: "arruda-algorithm")!
        let dog = DecisionNode(result: "You should get a dog.")
        let cat = DecisionNode(result: "You should get a cat.")
        let fish = DecisionNode(result: "You should get a fish.")
        let likesFur = DecisionNode(question: "Do you like fur?", trueBranch: dog, falseBranch: fish)
        let wantsPet = DecisionNode(question: "Do you want a pet?", trueBranch: likesFur, falseBranch: cat)

        DecisionTreeView(root: wantsPet)
    }
}


