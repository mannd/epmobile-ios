//
//  SmartWpw.swift
//  EP Mobile
//
//  Created by David Mann on 11/7/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct SmartWpw: Algorithm {
    var name: String = "SMART-WPW"
    var resultTitle: String = "Accessory Pathway Location"
    var hasMap: Bool = false

    var rootNode: DecisionNode = {
        // Attempt to locate the decision tree resource named "Hamriti" in the main bundle.
        // Adjust the extension if your resource has one (e.g., "json").
        if let url = Bundle.main.url(forResource: "smartWPW", withExtension: "json") {
            do {
                return try DecisionNode.load(from: url)
            } catch {
                fatalError("Failed to load decision tree 'smartWPW.json': \(error)")
            }
        }
        // If the resource isn't found, this is a programmer error; crash with a helpful message.
        fatalError("Unable to find resource 'smartWPW.json' in main bundle for SMART-WPW")
    }()

    // TODO: change to SmartWPW references
    func getReferences() -> [Reference] {
        let reference: Reference = Reference("Khalaph M, Trajkovska N, Didenko M, et al. A Novel ECG Algorithm for Accurate Localization of Manifest Accessory Pathways in Both Children and Adults: SMART-WPW. Heart Rhythm. 2025;0(0). doi:10.1016/j.hrthm.2025.04.058")
        return [reference]
    }

    func getInstructions() -> String? {
        "The SMART-WPW algorithm uses a different accessory pathway nomenclature than most of the other algorithms.  The results are mapped onto the mitral and tricuspid annuli presented in the form of clock faces viewed in the left anterior oblique view.  This is presented in Figure 1 from the reference paper, which unfortunately because of the high cost of reuse cannot be included in this app.\n\nThe paper states it uses the polarity of the delta wave of leads V1, V3, and the inferior leads (II, III, aVF) to determine the accessory pathway location.  However note that the algorithm considers both a fully negative delta wave and a small initial r wave followed by a deep S wave (rS) wave as a negative delta wave.\n\nPlease read the reference before using this or any other algorithm."
    }

    func getKey() -> String? {
        return nil
    }
}

