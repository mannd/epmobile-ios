//
//  QTcCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class QTcCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let qtcCalculator = QTcCalculator()
        let hostingVC = UIHostingController(rootView: qtcCalculator)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
