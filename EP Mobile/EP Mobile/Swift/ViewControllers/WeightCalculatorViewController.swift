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
    static let name = "Weight Calculator"

    @objc
    static func show(vc: UIViewController) {
        let weightCalculatorView = WeightCalculatorView()
        let hostingVC = UIHostingController(rootView: weightCalculatorView)
        hostingVC.title = name

        let informationView = InformationView(instructions: Weight.getInstructions(),key: Weight.getKey(), references: Weight.getReferences(), name: name, keyTitle: "Copy and Paste Weights")

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView:  informationView)

        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }
}
