//
//  AnswerOptionTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/13/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

struct AnswerOptionTests {

    @Test func testAnswerOptions() async throws {
        let option1 = AnswerOption.value(rawValue: "yes")
        #expect(option1 == .yes)
        let option2 = AnswerOption.value(rawValue: "no")
        #expect(option2 == .no)
        let option3 = AnswerOption.value(rawValue: "garbage")
        #expect(option3 == .none)
    }

}
