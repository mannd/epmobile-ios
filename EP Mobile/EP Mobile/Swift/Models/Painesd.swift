//
//  Painesd.swift
//  EP Mobile
//
//  Created by David Mann on 10/21/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

class Painesd: EPSRiskScore {
    override
    func getTitle() -> String! {
        return "PAINESCD"
    }

    override
    func getReferences() -> [Any]! {
        let references = [Reference("Muser D, Castro SA, Liang JJ, Santangeli P. Identifying Risk and Management of Acute Haemodynamic Decompensation During Catheter Ablation of Ventricular Tachycardia. Arrhythm Electrophysiol Rev. 2018;7(4):282-287. doi:10.15420/aer.2018.36.3")]
        return references
    }

    override
    func getInstructions() -> String! {
        return "The PAINESD score estimates the risk of periprocedural acute hemodynamic decompensation (AHD) in patients undergoing catheter ablation of ventricular tachycardia. AHD is defined as an event with a blood pressure < 90 despite vasopressors that requires a mechanical assist device.\n\nAHD occurs in approximately 11% of patients. Patients requiring an LV assist device had a 58.3% 30 day mortality compared to 3.5% in those not requiring mechanical hemodynamic support.\n\nThe score can classify subjects into low, medium, or high risk of developing AHD."
    }

    override
    func getKey() -> String! {
        return nil
    }

    override func getArray() -> NSMutableArray! {
        let array: NSMutableArray = []
        array.add(EPSRiskFactor("Pulmonary disease (COPD)", withValue: 5) as Any)
        array.add(EPSRiskFactor("Age > 60", withValue: 3) as Any)
        array.add(EPSRiskFactor("Ischemic cardiomyopathy", withValue: 6) as Any)
        array.add(EPSRiskFactor("NYHA class III or IV", withValue: 6) as Any)
        array.add(EPSRiskFactor("EF (LVEF) < 25%", withValue: 3) as Any)
        array.add(EPSRiskFactor("Storm - presentation with VT storm", withValue: 5) as Any)
        array.add(EPSRiskFactor("Diabetes", withValue: 3) as Any)
        return array
    }

    override func getMessage(_ score: Int32) -> String! {
        var message: String = "PAINESD Score: \(score)"
        var risk: String = ""
        if score < 9 {
            risk = "1% - very low risk" 
        } else if score < 15 {
            risk = "6% - moderate risk"
        } else {
            risk = "24% - high riak"
        }
        message += "\nRisk of periprocedure acute hemodynamic decompensation: \(risk)"
        return message
    }
}
