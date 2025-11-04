//
//  AlgorithmView.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let viewName = "Algorithm View"

struct AlgorithmView: View {
    private var title: String?
    private var hasMap: Bool = true
    @State private var algorithmResult: String?
    @State private var nodeStack: [NewDecisionNode] = []
    @State private var showInfo: Bool = false
    @State private var showResult: Bool = false
    @State var model: NewAlgorithm
    @State private var currentNode: NewDecisionNode
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    init(model: NewAlgorithm) {
        _model = .init(initialValue: model)
        currentNode = model.rootNode
        title = model.name
    }

    var body: some View {
        NavigationView {
            VStack {
                if let question = currentNode.question {
                    Text(question)
                        .font(.title)
                        .padding()
                }
                if let note = currentNode.note {
                    Text(note)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                if let result = currentNode.result {
                    Text(result)
                        .font(.title)
                        .padding()
                } else {
                    if let branches = currentNode.branches {
                        CenteringGridLayout(columns: 2, spacing: 16, itemSpacing: 16)
                        {
                            ForEach(branches, id: \.self) {branch in
                                Button(branch.label) {
                                    evaluateNode(branch)
                                    moveToNextBranch(branch: branch)
                                }
                                .roundedButton()
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
            }
            .alert(model.resultTitle, isPresented: $showResult, presenting: algorithmResult) { _ in
                Button("OK", role: .cancel) {
                    reset()
                }
                if hasMap {
                    Button("Show Map") {
                        showMap()
                    }
                }
            } message: { result in
                Text(result)
            }
            .padding()
            .navigationBarTitle(Text(title ?? "Decision Tree"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    NavigationLink(
                        destination: InformationView(
                            instructions: model.getInstructions(),
                            key: model.getKey(),
                            references: model.getReferences(),
                            name: model.name)
                    ) {
                        Image(systemName: "info.circle")
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func moveToNextBranch(branch: NewDecisionNode) {
        if branch.isLeaf { return }
        nodeStack.append(currentNode)
        currentNode = branch
    }

    func evaluateNode(_ node: NewDecisionNode) {
        algorithmResult = node.result
        showResult = node.isLeaf
    }

    func reset() {
        currentNode = model.rootNode
        nodeStack.removeAll()
        showResult = false
    }

    func showMap() {
        // TODO:
    }

}

#Preview {
    AlgorithmView(model: EasyWpw())
}
