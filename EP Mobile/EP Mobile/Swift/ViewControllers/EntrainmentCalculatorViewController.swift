//
//  EntrainmentCalculatorViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/19/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class EntrainmentCalculatorViewController: NSObject {
    static let name = "Entrainment Map"

    @objc
    static func show(vc: UIViewController) {
        let entrainmentCalculatorView = EntrainmentCalculatorView()
        let hostingVC = UIHostingController(rootView: entrainmentCalculatorView)
        hostingVC.title = name

        let informationView = InformationView(instructions: Entrainment.getInstructions(), references: Entrainment.getReferences(), name: name)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
