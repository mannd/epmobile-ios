//
//  RiskScoreViewController.swift
//  EP Mobile
//
//  Created by David Mann on 9/30/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class RiskScoreViewController: NSObject {

    @objc
    static func show(vc: UIViewController, riskScore: EPSRiskScore) {
        let riskScoreView = RiskScoreView(riskScore: riskScore)
        let hostingVC = UIHostingController(rootView: riskScoreView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
