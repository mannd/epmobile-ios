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

    @Test func testLoadJson() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let node = MultipleDecisionNode.loadDecisionTree(from: "arruda-algorithm")
        #expect(node != nil)
        #expect(!node!.isLeaf)
//        // TODO: this is a temporary fragile question, should remove.
        #expect(node!.question == "Is the delta wave in lead I negative or isoelectric or is the R wave is greater in amplitude than the S wave in lead V1?")
//        #expect(node!.result == nil)
//        #expect(node!.note == nil)
    }

}
