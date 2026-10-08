//
//  V2CalculatorViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/29/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class V2CalculatorViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let v2CalculatorView = V2CalculatorView()
        let hostingVC = UIHostingController(rootView: v2CalculatorView)
        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }
}
