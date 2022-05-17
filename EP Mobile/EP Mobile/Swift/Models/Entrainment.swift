//
//  Entrainment.swift
//  EP Mobile
//
//  Created by David Mann on 5/16/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct Entrainment {
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
        if let sQrs = sQrs {
            let sQrsFraction = sQrs / tcl
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
        if let egQrs = egQrs, let sQrs = sQrs {
            let egMinusQrs = egQrs - sQrs
            if abs(egMinusQrs) <= 20 {
                return .similarStimEgm
            } else {
                return .dissimilarStimEgm
            }
        }
        // ? return an error.  Shouldn't be able to get here...
        return .none
    }

    func ppiMinusTcl() -> Double {
        return ppi - tcl
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
    case similarStimEgm
    case dissimilarStimEgm

    case none

}
