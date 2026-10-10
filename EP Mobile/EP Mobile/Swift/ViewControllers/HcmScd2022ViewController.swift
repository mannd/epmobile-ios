//
//  HCMSCD2022ViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmScd2022ViewController: NSObject {
    static let name = "HCM SCD 2022 (ESC)"

    @objc
    static func show(vc: UIViewController) {
        let hcmScd2022View = HcmScd2022View()
        let hostingVC = UIHostingController(rootView: hcmScd2022View)
        hostingVC.title = name

       let informationView = InformationView(instructions: HcmScd2022Model.getInstructions(), key: HcmScd2022Model.getKey(), references: HcmScd2022Model.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
