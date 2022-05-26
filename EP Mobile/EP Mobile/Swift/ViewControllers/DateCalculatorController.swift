//
//  DateCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 4/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class DateCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let dateCalculator = DateCalculator()
        let hostingVC = UIHostingController(rootView: dateCalculator)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
