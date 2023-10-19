//
//  FrailtyTests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class FrailtyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEntryValidation() throws {
        var frailty = FrailtyModel()
        frailty.fitness.value = 10
        XCTAssertNoThrow(try frailty.validateEntries())
        frailty.fitness.value = 11
        XCTAssertThrowsError(try frailty.validateEntries())
        frailty.fitness.value = 10
        frailty.feelNervous.value = 2
        XCTAssertNoThrow(try frailty.validateEntries())
    }

    func testCalculate() {
        var frailty = FrailtyModel()
        var score = frailty.score()
        XCTAssertEqual(0, score)
        frailty.fitness.value = 10
        score = frailty.score()
        XCTAssertEqual(0, score)
        // sometimesNoRule
        frailty.poorMemory.value = 0
        score = frailty.score()
        XCTAssertEqual(0, score)
        frailty.poorMemory.value = 1  // sometimes == no
        score = frailty.score()
        XCTAssertEqual(0, score)
        frailty.poorMemory.value = 2
        score = frailty.score()
        XCTAssertEqual(1, score)
        // sometimesYesRule
        frailty.feelNervous.value = 0
        score = frailty.score()
        XCTAssertEqual(1, score)
        frailty.feelNervous.value = 1
        score = frailty.score()
        XCTAssertEqual(2, score)  // sometimes == yes
        frailty.feelNervous.value = 2
        score = frailty.score()
        XCTAssertEqual(2, score)
        // yesNoRule
        frailty.shopping.value = 1
        score = frailty.score()
        XCTAssertEqual(3, score)
    }

    func testReferenceFormatting() {
        let ref = FrailtyModel.getReferences()
        XCTAssertEqual("Schuurmans H, Steverink N, Lindenberg S, Frieswijk N, Slaets JPJ. Old or Frail: What Tells Us More? The Journals of Gerontology Series A: Biological Sciences and Medical Sciences. 2004;59(9):M962-M965.\n[doi:10.1093/gerona/59.9.M962](https://doi.org/10.1093/gerona/59.9.M962)", ref[1].getReferenceWithMarkdownLink())
    }
}
