//
//  AlgoritmView.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let viewName = "Algorithm View"

struct AlgoritmView: View {
    private var title: String?
    @State private var showInfo: Bool = false
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
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(branches, id: \.self) {branch in
                                Button(branch.label) {
                                    moveToNextBranch(branch: branch)
                                }
                                .roundedButton()
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle(Text(title ?? "Decision Tree"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func moveToNextBranch(branch: NewDecisionNode) {
        currentNode = branch
////        if let nextNode = currentNode.branches![answer] {
////            if let result = nextNode.result {
////                self.result = result
////            }
////            else {
////                nodeStack.append(currentNode)
////                currentNode = nextNode
////            }
//        }
    }
}

#Preview {
    AlgoritmView(model: EasyWpw())
}
