//
//  NewDecisionTreeViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class NewDecisionTreeViewController: NSObject {

    @objc
    static func show(vc: UIViewController, algorithm: String? = nil) {
        guard let algorithm else { return }
        if let node = MultipleDecisionNode.loadDecisionTree(from: algorithm) {
            let decisionTreeView = DecisionTreeView2(rootNode: node, title: "Arruda Algorithm")
            let hostingVC = UIHostingController(rootView: decisionTreeView)
            vc.navigationController?.pushViewController(hostingVC, animated: true)
        }
    }
}
