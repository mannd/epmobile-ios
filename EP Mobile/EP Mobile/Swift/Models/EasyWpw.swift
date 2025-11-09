//
//  EasyWpw.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct EasyWpw: Algorithm {
    var name: String = "EASY-WPW"
    var resultTitle: String = "Accessory Pathway Location"
    var hasMap: Bool = true

    var rootNode: DecisionNode = {
        // Attempt to locate the decision tree resource named "Hamriti" in the main bundle.
        // Adjust the extension if your resource has one (e.g., "json").
        if let url = Bundle.main.url(forResource: "Hamriti", withExtension: "json") {
            do {
                return try DecisionNode.load(from: url)
            } catch {
                fatalError("Failed to load decision tree 'Hamriti.json': \(error)")
            }
        }
        // If the resource isn't found, this is a programmer error; crash with a helpful message.
        fatalError("Unable to find resource 'Hamriti' in main bundle for EASY-WPW")
    }()

    func getReferences() -> [Reference] {
        let reference: Reference = Reference("El Hamriti M, Braun M, Molatta S, et al. EASY-WPW: a novel ECG-algorithm for easy and reliable localization of manifest accessory pathways in children and adults. Europace. 2023;25(2):600-609. doi:10.1093/europace/euac216")
        return [reference]
    }
    
    func getInstructions() -> String? {
        "The EASY-WPW algorithm is based on both the analysis of QRS polarity and transition as well as the most positive delta wave or the most positive QRS complex if delta wave is not well differentiated. The delta wave is defined as the first 20–40 ms of the earliest QRS deflection."
    }
    
    func getKey() -> String? {
        return nil
    }
}

