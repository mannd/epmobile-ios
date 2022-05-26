//
//  WeightTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class WeightTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIdealBodyWeight() {
        let w1 = Weight(weight: Measurement(value: 70, unit: .kilograms), height: Measurement(value: 120, unit: .centimeters), sex: .male)
        XCTAssertEqual(w1.idealBodyWeight(), Measurement(value:50, unit: .kilograms))
        let w2 = Weight(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssertEqual(w2.idealBodyWeight().converted(to: .pounds).value, Measurement(value:211.64, unit: UnitMass.pounds).value, accuracy: 0.01)
    }

    func testAdjustedBodyWeight() {
        let w1 = Weight(weight: Measurement(value: 70, unit: .kilograms), height: Measurement(value: 120, unit: .centimeters), sex: .male)
        XCTAssertEqual(w1.adjustedBodyWeight(), Measurement(value:58.0, unit: .kilograms))
        let w2 = Weight(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssertEqual(w2.adjustedBodyWeight().converted(to: .pounds).value, Measurement(value:143.0, unit: UnitMass.pounds).value, accuracy: 0.01)
    }

    func testIsOverweight() {
        let w1 = Weight(weight: Measurement(value: 300, unit: .kilograms), height: Measurement(value: 70, unit: .inches), sex: .male)
        XCTAssert(w1.isOverweight())
        let w2 = Weight(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssertFalse(w2.isOverweight())
    }

    func testIsUnderHeight() {
        let w1 = Weight(weight: Measurement(value: 300, unit: .kilograms), height: Measurement(value: 59, unit: .inches), sex: .male)
        XCTAssert(w1.isUnderHeight())
        let w2 = Weight(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssertFalse(w2.isUnderHeight())
    }

    func testIsUnderweight() {
        let w1 = Weight(weight: Measurement(value: 100, unit: .pounds), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssert(w1.isUnderweight())
        let w2 = Weight(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 65, unit: .inches), sex: .male)
        XCTAssertFalse(w2.isUnderweight())
    }

    func testWeightCalculatorViewModel() {
        let vm1 = WeightCalculatorViewModel(weight: Measurement(value: 100, unit: .kilograms), height: Measurement(value: 80, unit: .inches), sex: .male)
        XCTAssertEqual(vm1.actualBodyWeight(), "Actual Body Weight = 100 kg")
        XCTAssertEqual(vm1.idealBodyWeight(), "Ideal Body Weight = 96 kg")
        XCTAssertEqual(vm1.adjustedBodyWeight(), "Adjusted Body Weight = 97.6 kg")
        XCTAssertEqual(vm1.rawIdealBodyWeight(), "96")
        XCTAssertEqual(vm1.rawAdjustedBodyWeight(), "97.6")
        XCTAssertEqual(vm1.rawActualBodyWeight(), "100")
        XCTAssertEqual(vm1.recommendedBodyWeight(), "Recommended Weight = Ideal Body Weight (96 kg)")
        let vm2 = WeightCalculatorViewModel(weight: Measurement(value: 143, unit: .pounds), height: Measurement(value: 65, unit: .inches), sex: .male)
        XCTAssertEqual(vm2.actualBodyWeight(), "Actual Body Weight = 143 lb")
        XCTAssertEqual(vm2.idealBodyWeight(), "Ideal Body Weight = 135.6 lb")
        XCTAssertEqual(vm2.adjustedBodyWeight(), "Adjusted Body Weight = 138.6 lb")
        XCTAssertEqual(vm2.rawIdealBodyWeight(), "135.6")
        XCTAssertEqual(vm2.rawAdjustedBodyWeight(), "138.6")
        XCTAssertEqual(vm2.rawActualBodyWeight(), "143")
        XCTAssertEqual(vm2.recommendedBodyWeight(), "Recommended Weight = Ideal Body Weight (135.6 lb)")


        let vm3 = WeightCalculatorViewModel(weight: Measurement(value: 300, unit: .kilograms), height: Measurement(value: 70, unit: .inches), sex: .male)
        XCTAssertEqual(vm3.recommendedBodyWeight(), "Recommended Weight = Adjusted Body Weight (163.8 kg)")
    }
}
