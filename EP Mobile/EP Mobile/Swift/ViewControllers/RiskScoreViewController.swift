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
        hostingVC.title = riskScore.getName()

        makeInformationView(vc: hostingVC, instructions: riskScore.getInstructions(), key: riskScore.getKey(), references: riskScore.getReferences() as! [Reference], name: riskScore.getName())

//        let informationAction = UIAction(
//            title: "",
//            image: UIImage(systemName: "info.circle")
//        ) { [weak hostingVC] _ in
//            guard let hostingVC else { return }
//
//            InformationViewPresenter.show(
//                vc: hostingVC,
//                instructions: riskScore.getInstructions(),
//                key: riskScore.getKey(),
//                references: riskScore.getReferences() as! [Reference],
//                name: riskScore.getName()
//            )
//        }
//        let informationButton = UIBarButtonItem(
//            primaryAction: informationAction
//        )
//        informationButton.accessibilityLabel = "Information"
//        hostingVC.navigationItem.rightBarButtonItem = informationButton

        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }

    static func makeInformationView(vc: UIViewController, instructions: String?, key: String?, references: [Reference], name: String) {
        let informationAction = UIAction(
            title: "",
            image: UIImage(systemName: "info.circle")
        ) { [weak vc] _ in
            guard let vc else { return }

            InformationViewPresenter.show(
                vc: vc,
                instructions: instructions,
                key: key,
                references: references,
                name: name
            )
        }
        let informationButton = UIBarButtonItem(
            primaryAction: informationAction
        )
        informationButton.accessibilityLabel = "Information"
        vc.navigationItem.rightBarButtonItem = informationButton
    }
}
