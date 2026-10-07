//
//  WeightCalculatorViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/11/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class WeightCalculatorCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let weightCalculatorView = WeightCalculatorView()
        let hostingVC = UIHostingController(rootView: weightCalculatorView)
        hostingVC.modalPresentationStyle = .fullScreen
        vc.navigationController?.present(hostingVC, animated: true)
    }
}
