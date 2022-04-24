//
//  IntervalRateCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 4/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class IntervalRateCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let intervalRateCalculator = IntervalRateCalculator()
        let hostingVC = UIHostingController(rootView: intervalRateCalculator)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
