//
//  WarfarinTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/12/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class WarfarinTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInrIsTherapeutic() {
        var w1 = Warfarin(inr: 2.0, weeklyDose: 150, tabletSize: 5, doseRange: 1...1.9)
        XCTAssertFalse(w1.inrIsTherapeutic())
        w1.doseRange = 1...2.0
        XCTAssert(w1.inrIsTherapeutic())
    }

    func testDoseChangeLowInrRange() {
        var w1 = Warfarin(inr: 3.7, weeklyDose: 150, tabletSize: 5, doseRange: 2...3)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().instruction, .holdOneDose)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().range, 10...15)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 5
        XCTAssertEqual(w1.getDoseChangeLowInrRange().instruction, .holdOneDose)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().range, 10...20)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 1
        XCTAssertNil(w1.getDoseChangeLowInrRange().instruction)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().range, 5...20)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().direction, DoseChangeDirection.increase)
        w1.inr = 2.0
        XCTAssertNil(w1.getDoseChangeLowInrRange().instruction)
        XCTAssertNil(w1.getDoseChangeLowInrRange().range)
        XCTAssertNil(w1.getDoseChangeLowInrRange().direction)
        w1.inr = 3.0
        XCTAssertNil(w1.getDoseChangeLowInrRange().instruction)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().range, 5...15)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 3.6
        XCTAssertNil(w1.getDoseChangeLowInrRange().instruction)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().range, 10...15)
        XCTAssertEqual(w1.getDoseChangeLowInrRange().direction, DoseChangeDirection.decrease)
    }

    func testDoseChangeHighInrRange() {
        var w1 = Warfarin(inr: 3.7, weeklyDose: 150, tabletSize: 5, doseRange: 2.5...3.5)
        XCTAssertNil(w1.getDoseChangeHighInrRange().instruction)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 5...15)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 5
        XCTAssertEqual(w1.getDoseChangeHighInrRange().instruction, .holdOneDose)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 10...20)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 1
        XCTAssertEqual(w1.getDoseChangeHighInrRange().instruction, .giveAdditionalDose)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 10...20)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, DoseChangeDirection.increase)
        w1.inr = 2.0
        XCTAssertNil(w1.getDoseChangeHighInrRange().instruction)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 5...15)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, .increase)
        w1.inr = 3.0
        XCTAssertNil(w1.getDoseChangeHighInrRange().instruction)
        XCTAssertNil(w1.getDoseChangeHighInrRange().range)
        XCTAssertNil(w1.getDoseChangeHighInrRange().direction)
        w1.inr = 4.6
        XCTAssertEqual(w1.getDoseChangeHighInrRange().instruction, .holdOneDose)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 10...20)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, DoseChangeDirection.decrease)
        w1.inr = 5.3
        XCTAssertEqual(w1.getDoseChangeHighInrRange().instruction, .holdTwoDoses)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().range, 10...20)
        XCTAssertEqual(w1.getDoseChangeHighInrRange().direction, DoseChangeDirection.decrease)
    }

    func testDoseChange() {
        var w1 = Warfarin(inr: 6.1, weeklyDose: 150, tabletSize: 5, doseRange: 2.5...3.5)
        XCTAssertEqual(w1.getDoseChange().instruction, .holdWarfarin)
        w1.inr = 3.0
        XCTAssertEqual(w1.getDoseChange().instruction, .therapeutic)
    }
}
