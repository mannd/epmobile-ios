//
//  DecisionTreeViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/14/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class DecisionTreeViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        // TODO: rootNode and title determined by chosen algorithm
        if let node = MultipleDecisionNode.loadDecisionTree(from: "arruda-algorithm") {
            let decisionTreeView = DecisionTreeView2(rootNode: node, title: "Arruda Algorithm")
            let hostingVC = UIHostingController(rootView: decisionTreeView)
            vc.navigationController?.pushViewController(hostingVC, animated: true)
        }
    }
}
