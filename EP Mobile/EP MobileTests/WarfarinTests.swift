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
        let w1 = Warfarin(inr: 2.0, weeklyDose: 150, tabletSize: 5, inrTarget: .high)
        XCTAssertFalse(w1.inrIsTherapeutic())

        let w2 = Warfarin(inr: 2.0, weeklyDose: 150, tabletSize: 5, inrTarget: .low)
        XCTAssert(w2.inrIsTherapeutic())
    }

    func testDoseChangeLowInrRange() {
        var w1 = Warfarin(inr: 3.7, weeklyDose: 150, tabletSize: 5, inrTarget: .low)
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
        var w1 = Warfarin(inr: 3.7, weeklyDose: 150, tabletSize: 5, inrTarget: .high)
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
        var w1 = Warfarin(inr: 6.1, weeklyDose: 150, tabletSize: 5, inrTarget: .high)
        XCTAssertEqual(w1.getDoseChange().instruction, .holdWarfarin)
        w1.inr = 3.0
        XCTAssertEqual(w1.getDoseChange().instruction, .therapeutic)
    }

    func testWarfarinViewModel() {
        let wvm1 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 2, inrTarget: .low)
        XCTAssertEqual(wvm1.calculate(), "INR is therapeutic. No change in warfarin dose.")
        XCTAssertFalse(wvm1.weeklyDoseIsSane())
        let wvm2 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 3, inrTarget: .low)
        XCTAssertEqual(wvm2.calculate(), "INR is therapeutic. No change in warfarin dose.")
        XCTAssertFalse(wvm2.weeklyDoseIsSane())
        let wvm3 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 2.5, inrTarget: .high)
        XCTAssertEqual(wvm3.calculate(), "INR is therapeutic. No change in warfarin dose.")
        XCTAssertFalse(wvm3.weeklyDoseIsSane())
        let wvm4 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 3.5, inrTarget: .high)
        XCTAssertEqual(wvm4.calculate(), "INR is therapeutic. No change in warfarin dose.")
        XCTAssertFalse(wvm4.weeklyDoseIsSane())

        let wvm5 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 6.01, inrTarget: .high)
        XCTAssertEqual(wvm5.calculate(), "Hold warfarin until INR back in therapeutic range.")
        XCTAssertFalse(wvm5.weeklyDoseIsSane())
        let wvm6 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 6.01, inrTarget: .low)
        XCTAssertEqual(wvm6.calculate(), "Hold warfarin until INR back in therapeutic range.")
        XCTAssertFalse(wvm6.weeklyDoseIsSane())

        let wvm7 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 5.01, inrTarget: .high)
        XCTAssertEqual(wvm7.calculate(), "Consider holding one dose.\nDecrease weekly dose by 10% (90.0 mg/wk) to 20% (80.0 mg/wk).")
        XCTAssertFalse(wvm7.weeklyDoseIsSane())
        let wvm8 = WarfarinViewModel(tabletSize: 1, weeklyDose: 7, inr: 3.2, inrTarget: .low)
        XCTAssertEqual(wvm8.calculate(), "Decrease weekly dose by 5% (7.0 mg/wk) to 15% (6.0 mg/wk).")
        XCTAssert(wvm8.weeklyDoseIsSane())
        let wvm9 = WarfarinViewModel(tabletSize: 2.5, weeklyDose: 155, inr: 4.1, inrTarget: .low)
        XCTAssertEqual(wvm9.calculate(), "Consider holding one dose.\nDecrease weekly dose by 10% (140.0 mg/wk) to 20% (124.0 mg/wk).")
        XCTAssertFalse(wvm9.weeklyDoseIsSane())
        let wvm10 = WarfarinViewModel(tabletSize: 5, weeklyDose: 100, inr: 1.5, inrTarget: .high)
        XCTAssertEqual(wvm10.calculate(), "Give additional dose.\nIncrease weekly dose by 10% (110.0 mg/wk) to 20% (120.0 mg/wk).")
        XCTAssertFalse(wvm10.weeklyDoseIsSane())
        let wvm11 = WarfarinViewModel(tabletSize: 10, weeklyDose: 200, inr: 4.5, inrTarget: .low)
        XCTAssertEqual(wvm11.calculate(), "Consider holding one dose.\nDecrease weekly dose by 10% (180.0 mg/wk) to 20% (160.0 mg/wk).")
        XCTAssertFalse(wvm11.weeklyDoseIsSane())
    }
}
