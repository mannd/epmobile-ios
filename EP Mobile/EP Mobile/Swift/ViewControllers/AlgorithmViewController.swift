//
//  AlgorithmViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc public enum AlgorithmType: Int {
    case easyWPW
    case smartWPW
    // Add other algorithms here as you implement them
}

@objc
final class AlgorithmViewController: NSObject {

    @objc
    static func show(vc: UIViewController, type: AlgorithmType) {
        let algorithm: any Algorithm
        switch type {
        case .easyWPW:
            algorithm = EasyWpw()
        case .smartWPW:
            algorithm = SmartWpw() 
        }

        let hostingVC = UIHostingController(rootView: AlgorithmView(model: algorithm))
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
