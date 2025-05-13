//
//  DecisionNodeTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/11/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

struct DecisionNodeTests {

    @Test func testLoadTestJson() async throws {
        let node = MultipleDecisionNode.loadDecisionTree(from: "test")
        #expect(node != nil)
        #expect(!node!.isLeaf)
        #expect(node!.question == "Do you like dogs?")
        #expect(node!.branches!.count == 2)
        #expect(node!.branches!["yes"]?.result == "Get a dog")
        #expect(node!.branches!["no"]?.question == "Do you like cats?")
        #expect(node!.branches!["no"]?.note == "Hates dogs")
        #expect(node!.branches!["no"]?.branches!.count == 3)
        #expect(node!.branches!["no"]?.branches!["yes"]?.result == "Get a cat")
        #expect(node!.branches!["no"]?.branches!["no"]?.result == "No pets for you")
        #expect(node!.branches!["no"]?.branches!["maybe"]?.result == "Decide")

    }

}
