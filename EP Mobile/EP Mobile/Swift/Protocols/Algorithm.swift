//
//  Algorithm.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

/// Basis of  algorithms, such as WPW or WCT algorithms in the app.
/// TODO: Convert all old UIKit views to new Algorithms.
protocol Algorithm {
    var name: String { get }
    var options: [AnswerOption] { get }
    var rootNode: MultipleDecisionNode { get }

    
}
