//
//  AppleScore.swift
//  EP Mobile
//
//  Created by David Mann on 11/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

class AppleScore: EPSRiskScore {
    override
    func getTitle() -> String! {
        return "APPLE Score"
    }

    override
    func getReferences() -> [Any]! {
        let references = [Reference("Kornej J, Hindricks G, Shoemaker MB, et al. The APPLE score: a novel and simple score for the prediction of rhythm outcomes after catheter ablation of atrial fibrillation. Clin Res Cardiol. 2015;104(10):871-876. doi:10.1007/s00392-015-0856-x"), Reference("Kornej J, Hindricks G, Arya A, Sommer P, Husser D, Bollmann A. The APPLE Score – A Novel Score for the Prediction of Rhythm Outcomes after Repeat Catheter Ablation of Atrial Fibrillation. PLoS One. 2017;12(1):e0169933. doi:10.1371/journal.pone.0169933")]
        return references
    }

    override
    func getInstructions() -> String? {
        return "Use this score to predict the risk of recurrent atrial fibrillation after initial or repeat catheter ablation.  You can use the GFR Calculator to determine estimated GFR."
    }

    override
    func getKey() -> String? {
        return nil
    }

    override func getArray() -> NSMutableArray! {
        let array: NSMutableArray = []
        array.add(EPSRiskFactor("Age > 65 years", withValue: 1) as Any)
        array.add(EPSRiskFactor("Persistent AF", withValue: 1) as Any)
        array.add(EPSRiskFactor("Impaired eGFR (< 60 ml/min/1.73 m²)", withValue: 1) as Any)
        array.add(EPSRiskFactor("LA diameter ≥ 43 mm", withValue: 1) as Any)
        array.add(EPSRiskFactor("EF < 50%", withValue: 1) as Any)

        return array
    }

    override func getMessage(_ score: Int32) -> String! {
        var message: String = ""
        var recurrenceRate = 0
        var repeatRecurrenceRate = 0
        switch (score) {
        case 0:
            recurrenceRate = 46;
            repeatRecurrenceRate = 18;
        case 1:
            recurrenceRate = 57;
            repeatRecurrenceRate = 38;
        case 2:
            recurrenceRate = 76;
            repeatRecurrenceRate = 39;
        case 3, 4, 5:
            recurrenceRate = 72;
            repeatRecurrenceRate = 56;
        default:
            recurrenceRate = 0;
            repeatRecurrenceRate = 0;
        }
        if recurrenceRate == 0 {
            message = "Error";
        } else {
            message = "Risk of AF recurrence following initial catheter ablation = \(recurrenceRate)%.\nRisk of AF recurrence following repeat catheter ablation = \(repeatRecurrenceRate)%.";
        }
        return message;
    }
}
