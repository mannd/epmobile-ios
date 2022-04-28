//
//  Drug.swift
//  EP Mobile
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum DrugName {
    case apixaban
    case dabigatran
    case dofetilide
    case edoxaban
    case rivaroxaban
    case sotalol
    case crCl // Not a drug, but used to just calculate crCl

    var description: String {
        switch self {
        case .apixaban:
            return "Apixaban"
        case .dabigatran:
            return "Dabigatran"
        case .dofetilide:
            return "Dofetilide"
        case .edoxaban:
            return "Edoxaban"
        case .rivaroxaban:
            return "Rivaroxaban"
        case .sotalol:
            return "Sotalol"
        case .crCl:
            return "Creatinine Clearance"
        }
    }
}

protocol Drug {
    func hasWarning() -> Bool
    func getDoseMessage() -> String
    func getDetails() -> String
}

final class DrugFactory {
    static func create(drugName: DrugName, patient: Patient) -> Drug? {
        switch drugName {
        case .crCl:
            return nil
        case .apixaban:
            return Apixaban(patient: patient)
//        case .dabigatran:
//            return Dabigatran()
//        case .dofetilide:
//            return Dofetilide()
//        case .edoxaban:
//            return Edoxaban()
//        case .rivaroxaban:
//            return Rivaroxaban()
//        case .sotalol:
//            return Sotalol()
        default:
            print("Drug Factory incomplete")
            return Apixaban(patient: patient)
        }
    }
}

final class Apixaban: Drug {
    let dose2_5Caution = "Avoid coadministration with strong dual inhibitors of CYP3A4 and P-gp"
    let dose5Caution =  "Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp"
    let esrdCaution = "\nUse with caution in patients with ESRD on dialysis"
    let inhibitors =  "(e.g. ketoconazole, itraconazole, ritonavir, clarithromycin)."

    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }
    func hasWarning() -> Bool {
        return patient.crCl < 15
    }

    func getDoseMessage() -> String {
        var dose: String = ""
        var message: String = ""
        var caution: String = ""
        if (patient.creatinineMgDL >= 1.5
            && patient.age >= 80 || patient.weightKg <= 60)
            || (patient.age >= 80 && patient.weightKg <= 60) {
            dose = "2.5"
            caution = dose2_5Caution
        } else {
            dose = "5"
            caution = dose5Caution
        }
        message = "Dose = \(dose) mg BID. \(caution) \(inhibitors)"
        if patient.crCl < 15 {
            message += esrdCaution
        }
        return message
    }

    func getDetails() -> String {
        return ""
    }
}



//final class Dabigatran: Drug {
//    var hasWarning: Bool
//
//    func getDose(patient: Patient) {
//        <#code#>
//    }
//
//    func getDetails(patient: Patient) {
//        <#code#>
//    }
//
//
//}
//
//final class Dofetilide: Drug {
//    var hasWarning: Bool
//
//    func getDose(patient: Patient) {
//        <#code#>
//    }
//
//    func getDetails(patient: Patient) {
//        <#code#>
//    }
//
//
//}
//
//final class Edoxaban: Drug {
//    var hasWarning: Bool
//
//    func getDose(patient: Patient) {
//        <#code#>
//    }
//
//    func getDetails(patient: Patient) {
//        <#code#>
//    }
//
//
//}
//
//final class Rivaroxaban: Drug {
//    var hasWarning: Bool
//
//    func getDose(patient: Patient) {
//        <#code#>
//    }
//
//    func getDetails(patient: Patient) {
//        <#code#>
//    }
//
//
//}
//
//final class Sotalol: Drug {
//    var hasWarning: Bool
//
//    func getDose(patient: Patient) {
//        <#code#>
//    }
//
//    func getDetails(patient: Patient) {
//        <#code#>
//    }


//}

