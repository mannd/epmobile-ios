//
//  BmiViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/3/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class BmiViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let bmiCalculatorView = BmiCalculatorView()
        let hostingVC = UIHostingController(rootView: bmiCalculatorView)

        // TODO: need to get the custom fields for the button creator
        //let key = BmiModel.getKey()

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}

