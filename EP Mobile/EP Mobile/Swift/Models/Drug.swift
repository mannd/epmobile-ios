//
//  Drug.swift
//  EP Mobile
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

@objc
enum DrugName: Int {
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

enum DrugWarning: String {
    case doNotUse = "DO NOT USE!"
}

protocol DrugDoseProvider{
    func hasWarning() -> Bool
    func getDoseMessage() -> String
    func getDetails() -> String
    func getDose() -> String
}

class Drug: DrugDoseProvider, InformationProvider {
    func hasWarning() -> Bool {
         return false
    }

    func getDoseMessage() -> String {
        return ""
    }

    func getDetails() -> String {
        return ""
    }

    func getDose() -> String {
        if getDetails().isEmpty {
            return getDoseMessage()
        }
        return getDoseMessage() + "\n" + getDetails()
    }

    static func getInstructions() -> String? {
        return nil
    }

    static func getKeys() -> String? {
        return nil
    }

    static func getReferences() -> [Reference] {
        return []
    }

    static func getCustomSectionText() -> String? {
        return "Do not rely on drug dose calculators unless you are fully familiar with these drugs and their dosing.  More detailed information on drug doses can be found in the Reference and Tools | Drug Reference module, which includes a creatinine clearance calculator.  \n\nAlso note that the doses calculated for the oral anticoagulant drugs are only for the treatment of non-valvular atrial fibrillation, not for other indications, such as DVT or PE.  Other factors not included in these calculators, such as pregnancy, nursing, liver dysfunction, concomitant drug use and adverse reactions can affect drug dosage."
    }

    static func getCustomSectionTitle() -> String? {
        return "Caution"
    }
}


final class DrugFactory {
    static func create(drugName: DrugName, patient: Patient) -> Drug? {
        switch drugName {
        case .crCl:
            return nil
        case .apixaban:
            return Apixaban(patient: patient)
        case .dabigatran:
            return Dabigatran(patient: patient)
        case .edoxaban:
            return Edoxaban(patient: patient)
        case .dofetilide:
            return Dofetilide(patient: patient)
        case .rivaroxaban:
            return Rivaroxaban(patient: patient)
        case .sotalol:
            return Sotalol(patient: patient)
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
    override func hasWarning() -> Bool {
        return patient.crCl < 15
    }

    override func getDoseMessage() -> String {
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

    override func getDetails() -> String {
        return ""
    }
}

final class Dabigatran: Drug {
    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }

    override func hasWarning() -> Bool {
        return patient.crCl <= 50
    }

    override func getDoseMessage() -> String {
        let dose: Int
        let crCl = patient.crCl
        if (crCl > 30) {
            dose = 150
        }
        else if (crCl >= 15) {
            dose = 75
        }
        else {
            dose = 0
        }
        if (dose == 0) {
            return DrugWarning.doNotUse.rawValue
        }
        return "Dose = \(dose) mg BID."
    }

    override func getDetails() -> String {
        let crCl = patient.crCl
        var message = ""
        if (crCl < 15) {
            return message
        }
        if (crCl <= 30) {
            message = "Avoid concomitant use of P-gp inhibitors (e.g. dronedarone)."
        }
        else if (crCl <= 50) {
            message = "Consider reducing dose to 75 mg BID when using with dronedarone or systemic ketoconazole."
        }
        if (patient.age >= 75) {
            message += " Possible increased bleeding risk (age > 75 y)."
        }
        return message;
    }


}

final class Dofetilide: Drug {
    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }

    override func hasWarning() -> Bool {
        patient.crCl < 20
    }

    override func getDoseMessage() -> String {
        let dose: Int
        let crCl = patient.crCl
        if crCl > 60 {
            dose = 500
        }
        else if crCl >= 40 {
            dose = 250
        }
        else if crCl >= 20 {
            dose = 125
        }
        else {
            dose = 0
        }
        if dose == 0 {
            return DrugWarning.doNotUse.rawValue
        }
        return "Dose = \(dose) mcg BID."
    }

    override func getDetails() -> String {
        return ""
    }
}

final class Edoxaban: Drug {
    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }

    override func hasWarning() -> Bool {
        return patient.crCl < 15 || patient.crCl > 95
    }

    override func getDoseMessage() -> String {
        var stringDose = ""
        let crCl = patient.crCl
        if crCl < 15 || crCl > 95 {
            stringDose = "0"
        } else {
            if crCl <= 50 && crCl >= 15 {
                stringDose = "30"
            } else {
                stringDose = "60"
            }
        }
        if stringDose == "0" {
            return DrugWarning.doNotUse.rawValue
        }
        return "Dose = \(stringDose) mg daily."
    }

    override func getDetails() -> String {
        if patient.crCl > 95 {
            return "Edoxaban should not be used in patients with CrCl > 95 mL/min"
        }
        return ""
    }
}

final class Rivaroxaban: Drug {
    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }

    override func hasWarning() -> Bool {
        return patient.crCl < 15
    }

    override func getDoseMessage() -> String {
        let crCl = patient.crCl
        var dose: Int
        if crCl > 50 {
            dose = 20
        }
        else if crCl >= 15 {
            dose = 15
        }
        else {
            dose = 0
        }
        if dose == 0 {
            return DrugWarning.doNotUse.rawValue
        }
        return "Dose = \(dose) mg daily. "
    }

    override func getDetails() -> String {
        if patient.crCl >= 15 {
            return "Take dose with evening meal."
        }
        return ""
    }
}

final class Sotalol: Drug {
    let patient: Patient

    init(patient: Patient) {
        self.patient = patient
    }

    override func hasWarning() -> Bool {
        return patient.crCl < 40
    }

    override func getDoseMessage() -> String {
        let crCl = patient.crCl
        var dose: Int
        if crCl >= 40 {
            dose = 80
        } else {
            return DrugWarning.doNotUse.rawValue
        }
        if crCl > 60 {
            return "Dose = \(dose) mg BID. "
        }
        return "Dose = \(dose) mg daily. "
    }

    override func getDetails() -> String {
        if patient.crCl < 40 {
            return ""
        }
        let message = "Recommended starting dose for treatment of atrial fibrillation. Initial QT should be < 450 msec. If QT remains < 500 msec dose can be increased to 120 mg or 160 mg "
        if patient.crCl > 60 {
            return message + "BID."
        }
        return message + "daily."
    }
}
