//
//  EntrainmentViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/19/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct EntrainmentViewModel {
    private var model: Entrainment

    init(tcl: Double, ppi: Double, concealedFusion: Bool, sQrs: Double?, egQrs: Double?) {
        model = Entrainment(tcl: tcl, ppi: ppi, concealedFusion: concealedFusion, sQrs: sQrs, egQrs: egQrs)
    }

    func calculate() -> String {
        var result = "PPI-TCL = \(Int(model.ppiMinusTcl())). "
        do {
            let entrainmentResult = try model.calculate()
            if model.concealedFusion && entrainmentResult != EntrainmentResult.adjacentBystander {
                result += "Inner loop or isthmus site of reentry circuit. "
            }
            switch entrainmentResult {
            case .remoteSite:
                result += "Remote site from reentry circuit."
            case .outerLoop:
                result += "Outer loop of reentry circuit."
            case .adjacentBystander:
                result += "Adjacent bystander pathway not in reentry circuit."
            case .isthmusExit:
                result += "Isthmus exit site."

            case .isthmusCentral:
                result += "Isthmus central site."
            case .isthmusProximal:
                result += "Isthmus proximal site."
            case .innerLoop:
                result += "Inner loop site."
            case .none:
                result += ""
            }
            if let similarSQrsEgQrs = model.similarSQrsEgQrs() {
                if similarSQrsEgQrs {
                    result += " Similar S-QRS and EG-QRS intervals suggest site in isthmus of reentry circuit."
                } else {
                    result += " Dissimilar S-QRS and EG-QRS intervals suggest site may be an adjacent bystander."
                }
            }
            if model.hasHighChanceOfSuccessfulAblation() {
                result += " Site has high chance of ablation success, if ablating VT."
            }
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            if let error = error as? EntrainmentError {
                switch error {
                case .invalidEntry:
                    return ErrorMessage.invalidEntry
                case .ppiTooShort:
                    return ErrorMessage.ppiTooShort
                case .invalidSQrs:
                    return ErrorMessage.invalidSQrs
                }
            }
            return ErrorMessage.invalidEntry
        }
    }


}
