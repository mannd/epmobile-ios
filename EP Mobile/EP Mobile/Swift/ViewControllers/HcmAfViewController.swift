//
//  HcmAfViewController.swift
//  EP Mobile
//
//  Created by David Mann on 11/23/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmAfViewController: NSObject {
    static let name = "HCM AF Risk"

    @MainActor @objc
    static func show(vc: UIViewController) {
        let view = HcmAfView()
        let hostingVC = UIHostingController(rootView: view)
        hostingVC.title = name

        let informationView = InformationView(instructions: HcmAfModel.getInstructions(), key: HcmAfModel.getKey(), references: HcmAfModel.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
