//
//  InformationProvider.swift
//  EP Mobile
//
//  Created by David Mann on 10/10/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

protocol InformationProvider {
    static func getReferences() -> [Reference]
    static func getInstructions() -> String?
    static func getKeys() -> String?
    static func getCustomSectionTitle() -> String?
    static func getCustomSectionText() -> String?
}

extension InformationProvider {
    static func getCustomSectionTitle() -> String? {
        return nil
    }

    static func getCustomSectionText() -> String? {
        return nil
    }
}
