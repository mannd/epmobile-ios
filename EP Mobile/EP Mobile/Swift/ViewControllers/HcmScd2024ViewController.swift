//
//  HCMSCD2024ViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmScd2024ViewController: NSObject {
    static let name = "HCM SCD 2024 (AHA/ACC)"

    @objc
    static func show(vc: UIViewController) {
        let hcmScd2020View = HcmScd2024View()
        let hostingVC = UIHostingController(rootView: hcmScd2020View)
        hostingVC.title = name

        let informationView = InformationView(instructions: HcmScd2024Model.getInstructions(), key: HcmScd2024Model.getKey(), references: HcmScd2024Model.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
