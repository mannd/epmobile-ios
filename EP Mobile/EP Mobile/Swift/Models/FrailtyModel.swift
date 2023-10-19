//
//  FrailtyModel.swift
//  EP Mobile
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import Foundation

enum FrailtyError: Error {
    case invalidEntry

    var description: String {
        switch self {
        case .invalidEntry:
            return ErrorMessage.invalidEntry
        }
    }
}

struct FrailtyModel: InformationProvider {
    // Tasks

    struct FrailtyEntry {
        var question: String
        var value: Int = 0
        var range: ClosedRange<Int> = 0...1
        var rule: (Int) -> Int = yesNoRule
    }

    static let yesNoRule = { (v: Int) -> Int in v == 1 ? 1 : 0 }
    static let fitnessRule = { (v: Int) -> Int  in (0...6).contains(v) ? 1 : 0 }
    static let sometimesNoRule = { (v: Int) -> Int in v == 2 ? 1 : 0}
    static let sometimesYesRule = { (v: Int) -> Int in v == 0 ? 0 : 1}

    var shopping = FrailtyEntry(question: "Shopping")
    var walkingOutside = FrailtyEntry(question: "Walking around outside (around the house or to the neighbours)")
    var dressing = FrailtyEntry(question: "Dressing and undressing")
    var goingToToilet = FrailtyEntry(question: "Going to the toilet")
    // Other questions
    var fitness = FrailtyEntry(question: "What mark do you give yourself for physical fitness? (Scale 0 to 10)", range: 0...10, rule: fitnessRule)
    var poorVision = FrailtyEntry(question: "Do you experience problems in daily life due to poor vision?", range: 0...2)
    var poorHearing = FrailtyEntry(question: "Do you experience problems in daily life due to being hard of hearing?", range: 0...3)
    var weightLoss = FrailtyEntry(question: "During the last 6 months have you lost a lot of weight unwillingly? (3 kg in 1 month or 6 kg in 2 months)", range: 0...1)
    var multipleMeds = FrailtyEntry(question: "Do you take 4 or more different types of medicine?", range: 0...1)
    var poorMemory = FrailtyEntry(question: "Do you have any complaints about your memory?", range: 0...2, rule: sometimesNoRule)
    var feelEmpty = FrailtyEntry(question: "Do you sometimes experience emptiness around yourself?", range: 0...2, rule: sometimesYesRule)
    var missPeople = FrailtyEntry(question: "Do you sometimes miss people around yourself?", range: 0...2, rule: sometimesYesRule)
    var feelAbandoned = FrailtyEntry(question: "Do you sometimes feel abandoned?", range: 0...2, rule: sometimesYesRule)
    var feelSad = FrailtyEntry(question: "Have you recently felt downhearted or sad?", range: 0...2, rule: sometimesYesRule)
    var feelNervous = FrailtyEntry(question: "Have you recently felt nervous or anxious?", range:0...2, rule: sometimesYesRule)

    func entries() -> [FrailtyEntry] {
        return [shopping, walkingOutside, dressing, goingToToilet, fitness, poorVision,
                poorHearing, weightLoss, multipleMeds, poorMemory, feelEmpty, missPeople, feelAbandoned,
                feelSad, feelNervous]
    }

    func validateEntries() throws {
        for entry in entries() {
            if !entry.range.contains(entry.value) {
                throw FrailtyError.invalidEntry
            }
        }
    }

    func calculate() -> Int {
        let results = entries().map { $0.rule($0.value) }
        return results.reduce(0, +)
    }

    // MARK: InformationProvider
    
    static func getReferences() -> [Reference] {
        var references: [Reference] = []
        let reference1 = Reference("Steverink N, Slaets, Schuurmans H, Lis  van. Measuring frailty. The Gerontologist. 2001;41:236-237.")
        let reference2 = Reference("Schuurmans H, Steverink N, Lindenberg S, Frieswijk N, Slaets JPJ. Old or Frail: What Tells Us More? The Journals of Gerontology Series A: Biological Sciences and Medical Sciences. 2004;59(9):M962-M965.\ndoi:10.1093/gerona/59.9.M962")
        let reference3 = Reference("Drubbel I, Bleijenberg N, Kranenburg G, et al. Identifying frailty: do the Frailty Index and Groningen Frailty Indicator cover different clinical perspectives? a cross-sectional study. BMC Fam Pract. 2013;14:64.\ndoi:10.1186/1471-2296-14-64")
        references.append(reference1)
        references.append(reference2)
        references.append(reference3)
        return references
    }
    
    static func getInstructions() -> String? {
        return nil
    }
    
    static func getKey() -> String? {
        return nil
    }
    
    
}
