//
//  DrugCalculatorController.swift
//  EP Mobile
//
//  Created by David Mann on 4/29/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class DrugCalculatorController: NSObject {

    @objc
    static func show(vc: UIViewController, drugName: DrugName) {
        let drugDoseCalculator = DrugDoseCalculator(drugName: .constant(drugName))
        let hostingVC = UIHostingController(rootView: drugDoseCalculator)
        hostingVC.title = drugName.description

        InformationViewPresenter.addInfoButton(to: hostingVC, instructions: BmiModel.getInstructions(), key: BmiModel.getKey(), references: BmiModel.getReferences(), name: BmiModel.name)





        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }


//
//    private func crClInformationView() -> InformationView {
//        return InformationView(references: Patient.getCrClReferences(), name: crClCalculatorName, optionalSectionTitle: "Notes", optionalSectionText: Patient.crClNotes)
//    }
//
//    private func gfrInformationView() -> InformationView {
//        return InformationView(instructions: Patient.getGfrInstructions(), references: Patient.getGfrReferences(), name: gfrCalculatorName)
//    }
//
//    private func drugDoseInformationView() -> InformationView {
//        return InformationView(references: Drug.getReferences(), name: drugCalculatorName, optionalSectionTitle: Drug.getCustomSectionTitle(), optionalSectionText: Drug.getCustomSectionText())
//    }
//
//    private func getInformationView() -> InformationView {
//        switch drugName {
//        case .crCl:
//            return crClInformationView()
//        case .gfr:
//            return gfrInformationView()
//        default:
//            return drugDoseInformationView()
//        }
//    }
}
