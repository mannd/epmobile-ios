//
//  DecisionNodeTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/11/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

final class DecisionNodeTestsMarker {}

struct DecisionNodeTests {

    @Test func testLoadTestJson() async throws {
        let bundle = Bundle(for: DecisionNodeTestsMarker.self)
        let url = try #require(bundle.url(forResource: "test", withExtension: "json"),
                               "Unable to find resource 'test.json' in test bundle")
        let rootNode = try DecisionNode.load(from: url)

        #expect(!rootNode.isLeaf)
        #expect(rootNode.question == "What is your favorite color?")
        #expect(rootNode.branches?.count == 3)
        let branch0 = rootNode.branches?[0]
        #expect(branch0?.question == "Why do you like red?")
        #expect(branch0?.isLeaf == false)
        #expect(branch0?.label == "Red")
        let branch1 = rootNode.branches?[1]
        #expect(branch1?.question == "Why do you like blue?")
        #expect(branch1?.isLeaf == false)
        #expect(branch1?.result == nil)
        #expect(branch1?.label == "Blue")
        let branch2 = rootNode.branches?[2]
        #expect(branch2?.question == "Why do you like green?")
        #expect(branch2?.isLeaf == false)
        #expect(branch2?.result == nil)
        #expect(branch2?.label == "Green")
        let branch1a = branch1?.branches?[0]
        #expect(branch1a?.question == nil)
        #expect(branch1a?.isLeaf == true)
        #expect(branch1a?.label == "It's calm")
        #expect(branch1a?.result == "You appreciate peace and stability.")
    }
}
