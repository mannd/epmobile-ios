//
//  QTcIvcdCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

@MainActor
@objc
final class QTcIvcdCalculatorController: NSObject {
    private static let calculatorName = "QTc IVCD Calculator"

    @objc
    static func show(vc: UIViewController) {
        guard let navigationController = vc.navigationController else { return }
        let calculator = QTcIvcdCalculatorView { [weak navigationController] results, formula, lbbb in
            guard let navigationController else { return }
            showResults(results, formula: formula, lbbb: lbbb, in: navigationController)
        }
        let hostingVC = makeHostingController(rootView: calculator, title: calculatorName)
        navigationController.pushViewController(hostingVC, animated: true)
    }

    private static func showResults(
        _ results: QTcIvcdResultList,
        formula: Formula,
        lbbb: Bool,
        in navigationController: UINavigationController
    ) {
        let resultsView = QTcIvcdResultView(
            qtcIvcdResultList: results,
            qtcFormula: formula
        ) { [weak navigationController] selectedFormula, value, detail in
            guard let navigationController else { return }
            let detailView = QTcIvcdResultDetail(
                formula: selectedFormula,
                value: value,
                detail: detail,
                lbbb: lbbb
            )
            let hostingVC = makeHostingController(rootView: detailView, title: "Details")
            navigationController.pushViewController(hostingVC, animated: true)
        }
        let hostingVC = makeHostingController(rootView: resultsView, title: "QTc with IVCD Results")
        navigationController.pushViewController(hostingVC, animated: true)
    }

    private static func makeHostingController<Content: View>(
        rootView: Content,
        title: String
    ) -> UIHostingController<Content> {
        let hostingVC = UIHostingController(rootView: rootView)
        hostingVC.title = title
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        let informationView = InformationView(
            instructions: QTcIvcd.getInstructions(),
            references: QTcIvcd.getReferences(),
            name: calculatorName
        )
        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)
        return hostingVC
    }
}
