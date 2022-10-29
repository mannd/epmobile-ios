//
//  Entrainment.swift
//  EP Mobile
//
//  Created by David Mann on 5/16/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct Entrainment: InformationProvider {
    let tcl: Double
    let ppi: Double
    let concealedFusion: Bool
    let sQrs: Double?
    let egQrs: Double?

    func calculate() throws -> EntrainmentResult {
        guard tcl > 0 && ppi > 0 else {
            throw EntrainmentError.invalidEntry
        }
        let ppiMinusTcl = ppiMinusTcl()
        guard ppiMinusTcl >= 0 else {
            throw EntrainmentError.ppiTooShort
        }
        if !concealedFusion {
            if ppiMinusTcl > 30 {
                return .remoteSite
            } else {
                return .outerLoop
            }
        }
        // concealed fusion present
        if ppiMinusTcl > 30 {
            return .adjacentBystander
        }
        // concealed fusion and short ppiMinusTcl present
        if let sQrs = sQrs, sQrs >= 0 {
            let sQrsFraction = sQrsFraction(sQrs: sQrs)
            if sQrsFraction < 0.3 {
                return .isthmusExit
            } else if sQrsFraction <= 0.5 {
                return .isthmusCentral
            } else if sQrsFraction <= 0.7 {
                return .isthmusProximal
            } else if sQrsFraction <= 1.0 {
                return .innerLoop
            } else {
                throw EntrainmentError.invalidSQrs
            }
        }
        // ? return an error.  Shouldn't be able to get here...
        return .none
    }

    func sQrsFraction(sQrs: Double) -> Double {
        return sQrs / tcl
    }

    func ppiMinusTcl() -> Double {
        return ppi - tcl
    }

    func similarSQrsEgQrs() -> Bool? {
        guard concealedFusion else { return nil }
        guard let sQrs = sQrs, let egQrs = egQrs else { return nil }
        guard sQrs >= 0, egQrs >= 0 else { return nil }
        let sQrsFraction = sQrsFraction(sQrs: sQrs)
        guard sQrsFraction <= 1.0 else {
            return nil
        }
        guard let egMinusQrs = egMinusQrs() else { return nil}
        return egMinusQrs <= 20.0
    }

    private func egMinusQrs() -> Double? {
        guard let sQrs = sQrs, let egQrs = egQrs else {
            return nil
        }
        guard sQrs >= 0 && egQrs >= 0 else { return nil }
        return abs(egQrs - sQrs)
    }

    func hasHighChanceOfSuccessfulAblation() -> Bool {
        guard let egQrs = egQrs, let egMinusQrs = egMinusQrs() else { return false }
        return concealedFusion && ppiMinusTcl() <= 10 && egQrs / tcl <= 0.7 && egMinusQrs <= 10
    }

    static func getReferences() -> [Reference] {
        return [Reference("Stevenson WG, Friedman PL, Sager PT, et al. Exploring Postinfarction Reentrant Ventricular Tachycardia With Entrainment Mapping. Journal of the American College of Cardiology. 1997;29(6):1180-1189. doi:10.1016/S0735-1097(97)00065-X"), Reference("El-Shalakany A, Hadjis T, Papageorgiou P, Monahan K, Epstein L, Josephson ME. Entrainment/Mapping Criteria for the Prediction of Termination of Ventricular Tachycardia by Single Radiofrequency Lesion in Patients With Coronary Artery Disease. Circulation. 1999;99(17):2283-2289. doi:10.1161/01.CIR.99.17.2283")]
    }

    static func getInstructions() -> String? {
        return "This Entrainment Mapping module is most suited for mapping ischemic ventricular tachycardia (VT), but principles of entrainment apply to all reentrant arrhythmias.\n\nEntrainment is performed by pacing during stable VT (or other reentrant tachycardia) for approximately 8-15 beat trains at 20-40 msec shorter than the tachycardia cycle length (TCL).  Make sure all electrograms are 'entrained', i.e. the CL shortens to the pacing CL.\n\nThe post-pacing interval (PPI) is measured from the last pacing stimulus to the next electrogram recorded from the pacing site.  Concealed fusion is present if the tachycardia morphology does not change during entrainment.  If there is concealed fusion then the pacing site is in an area of slow conduction near the critical isthmus of the reentry circuit.\n\nDuring VT if a discrete electrogram (EG) is present prior to the QRS onset then the EG-QRS interval can be measured.  During entrainment with concealed fusion, if there is a delay between the pacing stimulus to onset of the QRS (S-QRS), then the site is within the critical isthmus if the S-QRS interval is similar to the EG-QRS interval.  In addition the relative location within the critical isthmus can be estimated by the ratio of the S-QRS to the TCL.  Sites with concealed fusion but long PPI intervals are probably adjacent bystander tracts.\n\nPacing sites within the critical isthmus are associated with a much higher chance of successful tachycardia termination with ablation than other sites.\n\nEP Mobile uses the criteria of El-Shalakany et al. to identify VT sites with high likelihood of ablation success."
    }

    static func getKeys() -> String? {
        return nil
    }

}

enum EntrainmentError: Error {
    case invalidEntry
    case ppiTooShort
    case invalidSQrs
}

enum EntrainmentResult {
    case remoteSite
    case outerLoop
    case adjacentBystander
    case isthmusExit
    case isthmusCentral
    case isthmusProximal
    case innerLoop
    case none

}
