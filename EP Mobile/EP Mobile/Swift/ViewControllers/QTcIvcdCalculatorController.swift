//
//  QTcIvcdCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class QTcIvcdCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let qtcIvcdCalculatorView = QTcIvcdCalculatorView()
        let hostingVC = UIHostingController(rootView: qtcIvcdCalculatorView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
