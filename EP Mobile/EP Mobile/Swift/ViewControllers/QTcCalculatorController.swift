//
//  QTcCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

@objc
final class QTcCalculatorController: NSObject {
   static let name = "QTc Calculator"

    @objc
    static func show(vc: UIViewController) {
        let qtcCalculator = QTcCalculatorView()
        let hostingVC = UIHostingController(rootView: qtcCalculator)
        hostingVC.title = name

        let informationView = InformationView(instructions: QTcCalculator.getInstructions(), key: QTcCalculator.getKey(), references: QTcCalculator.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }
}
