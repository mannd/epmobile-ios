//
//  ArvcTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/13/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import Foundation
import XCTest
@testable import EP_Mobile

class ArvcTests: XCTestCase {

    func testTest() {
        XCTAssert(true)
    }

    func testArvcRisk() {
        let pt1 = ArvcRiskModel(sex: 0, age: 48, hxSyncope: 0, hxNSVT: 0, pvcCount: 1, twiCount: 4, rvef: 55)
        let result1 = pt1.calculateRisk()
        XCTAssertEqual(result1.year5Risk, 3.0)
        XCTAssertEqual(result1.year2Risk, 1.8)
        XCTAssertEqual(result1.year1Risk, 1.1)
        let pt2 = ArvcRiskModel(sex: 1, age: 50, hxSyncope: 0, hxNSVT: 0, pvcCount: 312, twiCount: 3, rvef: 48)
        let result2 = pt2.calculateRisk()
        XCTAssertEqual(result2.year5Risk, 12.7)
        XCTAssertEqual(result2.year2Risk, 7.8)
        XCTAssertEqual(result2.year1Risk, 4.9)
        let pt3 = ArvcRiskModel(sex: 0, age: 22, hxSyncope: 0, hxNSVT: 1, pvcCount: 20527, twiCount: 4, rvef: 28)
        let result3 = pt3.calculateRisk()
        XCTAssertEqual(result3.year5Risk, 72.8)
        XCTAssertEqual(result3.year2Risk, 54.0)
        XCTAssertEqual(result3.year1Risk, 38.1)
        let pt4 = ArvcRiskModel(sex: 1, age: 15, hxSyncope: 1, hxNSVT: 0, pvcCount: 1800, twiCount: 5, rvef: 66)
        let result4 = pt4.calculateRisk()
        XCTAssertEqual(result4.year5Risk, 45.2)
        XCTAssertEqual(result4.year2Risk, 30.2)
        XCTAssertEqual(result4.year1Risk, 19.9)
    }
}
