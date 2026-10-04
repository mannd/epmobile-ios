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

    @objc
    static func show(vc: UIViewController) {
        let qtcCalculator = QTcCalculatorView()
        let hostingVC = UIHostingController(rootView: qtcCalculator)
        hostingVC.title = "QTc Calculator"

        InformationViewPresenter.addInfoButton(to: hostingVC, instructions: nil , key: nil, references: QTcCalculator.getReferences(), name: "QTc Calculator")

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
