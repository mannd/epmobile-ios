//
//  AlgorithmView.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation
import UIKit
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
    
    @State private var mapConfig: AnnulusMapConfig? = nil
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    init(model: NewAlgorithm) {
        _model = .init(initialValue: model)
        currentNode = model.rootNode
        title = model.name
    }

    struct AnnulusMapConfig: Identifiable {
        let id = UUID()
        let message: String
        let location1: String?
        let location2: String?
        let showPathway: Bool
    }

    @ViewBuilder
    private func makeAnnulusMapView(config: AnnulusMapConfig) -> some View {
        AnnulusMapUIKitWrapper(message: config.message, location1: config.location1, location2: config.location2, showPathway: config.showPathway)
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
            .sheet(item: $mapConfig) { config in
                makeAnnulusMapView(config: config)
            }
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
        let message = algorithmResult ?? currentNode.result ?? "Accessory pathway map"
        // If the model can provide specific locations, thread them in via currentNode.tag or model API.
        // For now, we pass nils which will display the base map with message.
        let location1: String? = nil
        let location2: String? = nil
        let showPathway = true
        self.mapConfig = AnnulusMapConfig(message: message, location1: location1, location2: location2, showPathway: showPathway)
    }

}

// MARK: - Annulus Map UIKit Wrapper

import SwiftUI

private struct AnnulusMapUIKitWrapper: UIViewControllerRepresentable {
    let message: String
    let location1: String?
    let location2: String?
    let showPathway: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        // Load from WPW.storyboard where the AV Annulus scene lives
        let storyboard = UIStoryboard(name: "WPW", bundle: nil)

        // Try known identifiers in order. These must match the Storyboard ID set in Interface Builder.
        let candidates = [
            "AnnulusMap",               // provided storyboard ID
            "EPSAVAnnulusViewController", // class name, fallback
            "AVAnnulus"                   // legacy fallback
        ]

        var viewController: UIViewController?
        for id in candidates {
            if let vc = storyboard.instantiateViewController(withIdentifier: id) as? EPSAVAnnulusViewController {
                viewController = vc
                break
            } else {
                // If the identifier exists but is a different class, skip
                if let vc = try? storyboard.instantiateViewController(withIdentifier: id) {
                    // Identifier exists but not our class; continue searching
                    _ = vc
                }
            }
        }

        // Fall back to initial view controller if not found by identifier
        if viewController == nil, let initial = storyboard.instantiateInitialViewController() as? EPSAVAnnulusViewController {
            viewController = initial
        }

        // Final fallback: direct init (only works if VC supports init())
        let vc = (viewController as? EPSAVAnnulusViewController) ?? EPSAVAnnulusViewController()

        vc.showPathway = showPathway
        vc.location1 = location1
        vc.location2 = location2
        vc.message = message
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

#Preview {
    AlgorithmView(model: EasyWpw())
}

