//
//  DrugCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 4/29/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class DrugCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController, drugName: DrugName) {
//        let drugDoseCalculator = DrugDoseCalculator(drugName: .constant(DrugName(rawValue: drugNameRawValue)!))
        let drugDoseCalculator = DrugDoseCalculator(drugName: .constant(drugName))
        let hostingVC = UIHostingController(rootView: drugDoseCalculator)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
