//
//  HcmViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmViewController: NSObject {
    static let name = "HCM Risk-SCD 2014"

    @objc
    static func show(vc: UIViewController) {
        let hcmView = HcmRiskScdView()
        let hostingVC = UIHostingController(rootView: hcmView)
        hostingVC.title = name

        let informationView = InformationView(instructions: HcmRiskScdModel.getInstructions(), key: HcmRiskScdModel.getKey(), references: HcmRiskScdModel.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
