//
//  DoseMathTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import XCTest
@testable import EP_Mobile

class DoseMathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMassConversions() {
        XCTAssertEqual(MassUnits.lbToKg(70), 31.7515, accuracy: 0.0001)
        XCTAssertEqual(MassUnits.kgToLb(31.7515), 70.0, accuracy: 0.0001)
    }

    func testConcentrationConversions() {
        XCTAssertEqual(ConcentrationUnits.mgDLToMmolL(2), 176.84, accuracy: 0.001)
        XCTAssertEqual(ConcentrationUnits.mmolLToMgDL(150), 1.696, accuracy: 0.001)
    }

    func testCreatineClearance() {
        let doseMath = try! DoseMath(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(doseMath.creatinineClearance(), 97)
        let doseMath2 = try! DoseMath(age: 40, sex: .male, weight: 70, massUnits: .kg, creatinine: 1.0, concentrationUnits: .mgDL)
        XCTAssertEqual(doseMath2.creatinineClearance(), 97)
        let doseMath3 = try! DoseMath(age: 50, sex: .female, weight: 170, massUnits: .lb, creatinine: 100, concentrationUnits: .mmolL)
        XCTAssertEqual(doseMath3.creatinineClearance(), 72)
        let doseMath4 = try! DoseMath(age: 40, sex: .female, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(doseMath4.creatinineClearance(), 83)
    }
}
