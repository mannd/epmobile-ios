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
    case outOfRangeError

    var description: String {
        switch self {
        case .invalidEntry:
            return ErrorMessage.invalidEntry
        case .outOfRangeError:
            return ErrorMessage.outOfRange
        }
    }
}

struct FrailtyModel: InformationProvider, Equatable {
    static func == (lhs: FrailtyModel, rhs: FrailtyModel) -> Bool {
        for i in 0..<lhs.entries().count {
            if rhs.entries()[i].value != lhs.entries()[i].value {
                return false
            }
        }
        return true
    }

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

    static let mobilityQuestion = "Is the patient able to carry out these tasks single handed without any help? (The use of help resources such as walking stick, walking frame, wheelchair, is considered independent)"
    static let mobilityHeader = "Mobility"
    var shopping = FrailtyEntry(question: "Shopping")
    var walkingOutside = FrailtyEntry(question: "Walking around outside (around the house or to the neighbours)")
    var dressing = FrailtyEntry(question: "Dressing and undressing")
    var goingToToilet = FrailtyEntry(question: "Going to the toilet")

    static let fitnessHeader = "Physical Fitness"
    // Default value of 10 goes along with other default values that assume no frailty.
    var fitness = FrailtyEntry(question: "What mark does the patient give himself/herself for physical fitness? (Scale 0 to 10)", value: 10, range: 0...10, rule: fitnessRule)

    static let visionHeader = "Vision"
    var poorVision = FrailtyEntry(question: "Does the patient experience problems in daily life due to poor vision?", range: 0...2)

    static let hearingHeader = "Hearing"
    var poorHearing = FrailtyEntry(question: "Does the patient experience problems in daily life due to being hard of hearing?", range: 0...3)

    static let nourishmentHeader = "Nourishment"
    var weightLoss = FrailtyEntry(question: "During the last 6 months has the patient lost a lot of weight unwillingly? (3 kg in 1 month or 6 kg in 2 months)", range: 0...1)

    static let morbidityHeader = "Morbidity"
    var multipleMeds = FrailtyEntry(question: "Does the patient take 4 or more different types of medicine?", range: 0...1)

    static let cognitionHeader = "Cognition (Perception)"
    var poorMemory = FrailtyEntry(question: "Does the patient have any complaints about his/her memory or is the patient known to have a dementia syndrome?", range: 0...2, rule: sometimesNoRule)

     static let psychosocialHeader = "Psychosocial"
    var feelEmpty = FrailtyEntry(question: "Does the patient sometimes experience emptiness around him/her?", range: 0...2, rule: sometimesYesRule)
    var missPeople = FrailtyEntry(question: "Does the patient sometimes miss people around him/her?", range: 0...2, rule: sometimesYesRule)
    var feelAbandoned = FrailtyEntry(question: "Does the patient sometimes feel abandoned?", range: 0...2, rule: sometimesYesRule)
    var feelSad = FrailtyEntry(question: "Has the patient recently felt downhearted or sad?", range: 0...2, rule: sometimesYesRule)
    var feelNervous = FrailtyEntry(question: "Has the patient recently felt nervous or anxious?", range:0...2, rule: sometimesYesRule)

    func entries() -> [FrailtyEntry] {
        return [shopping, walkingOutside, dressing, goingToToilet, fitness, poorVision,
                poorHearing, weightLoss, multipleMeds, poorMemory, feelEmpty, missPeople, feelAbandoned,
                feelSad, feelNervous]
    }

    func validateEntries() throws {
        for entry in entries() {
            if !entry.range.contains(entry.value) {
                throw FrailtyError.outOfRangeError
            }
        }
    }

    func calculate() -> String {
        let results = entries().map { $0.rule($0.value) }
        let score = results.reduce(0, +)
        var message = "Score = \(score)\n"
        message += score >= 4 ? "Score indicates frailty." : "Score doesn't indicate frailty."
        return message
    }

    func getDetails() -> String {
        var result = "Risk score: Groningen Frailty Indicator"
        result += "\n(note the numbers are the points generated"
        result += "\nby the answers to the questions, not the answers themselves.)"
        result += "\nRisks:"
        result += "\nDifficulty shopping: \(shopping.rule(shopping.value))"
        result += "\nDifficulty walking: \(walkingOutside.rule(walkingOutside.value))"
        result += "\nDifficulty dressing: \(dressing.rule(dressing.value))"
        result += "\nDifficulty going to the toilet: \(goingToToilet.rule(goingToToilet.value))"
        result += "\nPhysical fitness: \(fitness.rule(fitness.value))"
        result += "\nPoor vision: \(poorVision.rule(poorVision.value))"
        result += "\nPoor hearing: \(poorHearing.rule(poorHearing.value))"
        result += "\nWeight loss: \(weightLoss.rule(weightLoss.value))"
        result += "\nMultiple medications: \(multipleMeds.rule(multipleMeds.value))"
        result += "\nMemory loss: \(poorMemory.rule(poorMemory.value))"
        result += "\nExperience emptiness: \(feelEmpty.rule(feelEmpty.value))"
        result += "\nMiss people: \(missPeople.rule(missPeople.value))"
        result += "\nFeel abandoned: \(feelAbandoned.rule(feelAbandoned.value))"
        result += "\nFeel sad: \(feelSad.rule(feelSad.value))"
        result += "\nFeel nervous: \(feelNervous.rule(feelNervous.value))"
        result += "\n"
        result += calculate()
        result += "\nReferences:\n"
        for reference in Self.getReferences() {
            result += reference.getPlainTextReference()
            result += "\n"
        }
        return result
    }

    // MARK: InformationProvider

    static func getReferences() -> [Reference] {
        var references: [Reference] = []
        let reference1 = Reference("Steverink N, Slaets, Schuurmans H, Lis  van. Measuring frailty. The Gerontologist. 2001;41:236-237.")
        let reference2 = Reference("Schuurmans H, Steverink N, Lindenberg S, Frieswijk N, Slaets JPJ. Old or Frail: What Tells Us More? The Journals of Gerontology Series A: Biological Sciences and Medical Sciences. 2004;59(9):M962-M965. doi:10.1093/gerona/59.9.M962")
        let reference3 = Reference("Drubbel I, Bleijenberg N, Kranenburg G, et al. Identifying frailty: do the Frailty Index and Groningen Frailty Indicator cover different clinical perspectives? a cross-sectional study. BMC Fam Pract. 2013;14:64. doi:10.1186/1471-2296-14-64")
        references.append(reference1)
        references.append(reference2)
        references.append(reference3)
        return references
    }

    static func getInstructions() -> String? {
        return "The Groningen Frailty Indicator (GFI) is a validated, 15-item questionnaire with a score range from zero to fifteen that assesses the physical, cognitive, social, and psychological domains. A GFI score of four or greater is considered the cut-off point for frailty."
    }

    static func getKey() -> String? {
        return nil
    }


}
