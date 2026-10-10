//
//  FrailtyViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class FrailtyViewController: NSObject {

    static let name = "Groningen Frailty Indicator"

    @objc
    static func show(vc: UIViewController) {
        let frailtyView = FrailtyView()
        let hostingVC = UIHostingController(rootView: frailtyView)
        hostingVC.title = name

        let informationView = InformationView(instructions: FrailtyModel.getInstructions(), key: FrailtyModel.getKey(), references: FrailtyModel.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
