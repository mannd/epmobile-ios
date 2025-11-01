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
        let newAlgorithm = EasyWpw()
        let hostingVC = UIHostingController(rootView: AlgoritmView(model: newAlgorithm))
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
