//
//  DrugCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 4/29/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let crClCalculatorName = "Creatinine Clearance"
fileprivate let gfrCalculatorName = "GFR"
fileprivate let drugCalculatorName = "Drug Calculators"

@objc
final class DrugCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController, drugName: DrugName) {
        let drugDoseCalculator = DrugDoseCalculator(drugName: .constant(drugName))
        let hostingVC = UIHostingController(rootView: drugDoseCalculator)
        hostingVC.title = drugName.description

        let informationView = Self.getInformationView(drugName: drugName)

        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)

        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }

    private static func crClInformationView() -> InformationView {
        return InformationView(references: Patient.getCrClReferences(), name: crClCalculatorName, optionalSectionTitle: "Notes", optionalSectionText: Patient.crClNotes)
    }

    private static func gfrInformationView() -> InformationView {
        return InformationView(instructions: Patient.getGfrInstructions(), references: Patient.getGfrReferences(), name: gfrCalculatorName)
    }

    private static func drugDoseInformationView() -> InformationView {
        return InformationView(references: Drug.getReferences(), name: drugCalculatorName, optionalSectionTitle: Drug.getCustomSectionTitle(), optionalSectionText: Drug.getCustomSectionText())
    }

    private static func getInformationView(drugName: DrugName) -> InformationView {
        switch drugName {
        case .crCl:
            return Self.crClInformationView()
        case .gfr:
            return Self.gfrInformationView()
        default:
            return Self.drugDoseInformationView()
        }
    }
}
