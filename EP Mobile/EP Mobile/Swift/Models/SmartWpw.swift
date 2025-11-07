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
        "The EASY-WPW algorithm is based on both the analysis of QRS polarity and transition as well as the most positive delta wave or the most positive QRS complex if delta wave is not well differentiated. The delta wave is defined as the first 20–40 ms of the earliest QRS deflection."
    }

    func getKey() -> String? {
        return nil
    }
}

