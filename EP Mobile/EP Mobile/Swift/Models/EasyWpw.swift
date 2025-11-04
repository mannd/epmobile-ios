//
//  EasyWpw.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct EasyWpw: NewAlgorithm {
    var name: String = "EASY-WPW"
    var resultTitle: String = "Accessory Pathway Location"

    var rootNode: NewDecisionNode = {
        // Attempt to locate the decision tree resource named "Hamriti" in the main bundle.
        // Adjust the extension if your resource has one (e.g., "json").
        if let url = Bundle.main.url(forResource: "Hamriti", withExtension: "json") {
            do {
                return try NewDecisionNode.load(from: url)
            } catch {
                fatalError("Failed to load decision tree 'Hamriti.json': \(error)")
            }
        }
        // If the resource isn't found, this is a programmer error; crash with a helpful message.
        fatalError("Unable to find resource 'Hamriti' in main bundle for EASY-WPW")
    }()

    func getReferences() -> [Reference] {
        let reference: Reference = Reference("EASY-WPW reference placeholder")
        return [reference]
    }
    
    func getInstructions() -> String? {
        "EASY-WPW instructions placeholder"
    }
    
    func getKey() -> String? {
        "EASY-WPW key placeholder"
    }
}

@objcMembers
public class EasyWpwObjC: NSObject {
    private let impl = EasyWpw()

    public override init() {
        super.init()
    }

    public var name: String { impl.name }
}
