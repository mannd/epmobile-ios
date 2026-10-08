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
    static let name = "Date Calculator"

    @objc
    static func show(vc: UIViewController) {
        let dateCalculator = DateCalculator()
        let hostingVC = UIHostingController(rootView: dateCalculator)
        hostingVC.title = name

        addInfoButton(to: hostingVC)

        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }

    static func addInfoButton(to vc: UIViewController) {

        let informationAction = UIAction(
            title: "",
            image: UIImage(systemName: "info.circle")
        ) { [weak vc] _ in
            guard let vc else { return }

            let dateInfoView = DateInfoView()
            let hostingVC = UIHostingController(rootView: dateInfoView)
            vc.navigationController?.pushViewController(hostingVC, animated: true)
        }
        let informationButton = UIBarButtonItem(
            primaryAction: informationAction
        )
        informationButton.accessibilityLabel = "Information"
        vc.navigationItem.rightBarButtonItem = informationButton
    }
}
