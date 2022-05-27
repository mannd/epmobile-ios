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

    func testArvcRisk() {
        let pt1 = ArvcRiskModel(sex: 0, age: 48, hxSyncope: 0, hxNSVT: 0, pvcCount: 1, twiCount: 4, rvef: 55)
        let result1 = pt1.calculateRisk()
        XCTAssertEqual(result1.year5Risk, 2.4)
        XCTAssertEqual(result1.year2Risk, 1.4)
        XCTAssertEqual(result1.year1Risk, 0.9)
        let pt2 = ArvcRiskModel(sex: 1, age: 50, hxSyncope: 0, hxNSVT: 0, pvcCount: 312, twiCount: 3, rvef: 48)
        let result2 = pt2.calculateRisk()
        XCTAssertEqual(result2.year5Risk, 10.1)
        XCTAssertEqual(result2.year2Risk, 6.2)
        XCTAssertEqual(result2.year1Risk, 3.8)
        let pt3 = ArvcRiskModel(sex: 0, age: 22, hxSyncope: 0, hxNSVT: 1, pvcCount: 20527, twiCount: 4, rvef: 28)
        let result3 = pt3.calculateRisk()
        XCTAssertEqual(result3.year5Risk, 64.1)
        XCTAssertEqual(result3.year2Risk, 45.8)
        XCTAssertEqual(result3.year1Risk, 31.4)
        let pt4 = ArvcRiskModel(sex: 1, age: 15, hxSyncope: 1, hxNSVT: 0, pvcCount: 1800, twiCount: 5, rvef: 66)
        let result4 = pt4.calculateRisk()
        XCTAssertEqual(result4.year5Risk, 37.7)
        XCTAssertEqual(result4.year2Risk, 24.6)
        XCTAssertEqual(result4.year1Risk, 16.0)
        let pt5 = ArvcRiskModel(sex: 1, age: 15, hxSyncope: 1, hxNSVT: 0, pvcCount: 0, twiCount: 5, rvef: 66)
        let result5 = pt5.calculateRisk()
        XCTAssertEqual(result5.year5Risk, 12.4)
        XCTAssertEqual(result5.year2Risk, 7.6)
        XCTAssertEqual(result5.year1Risk, 4.8)
    }

    // LTVA calculator examples in the source references seems to have errors.
    // Thus we will not include this calculator in EP Mobile.
//    func testLtvaArvcRisk() {
//        let pt1 = ArvcRiskModel(sex: 0, age: 19, hxSyncope: 0, hxNSVT: 0, pvcCount: 1, twiCount: 3, rvef: 57)
//        let result1 = pt1.ltvaCalculateRisk()
//        XCTAssertEqual(result1.year5Risk, 4.5)
//        XCTAssertEqual(result1.year2Risk, 2.9)
//        XCTAssertEqual(result1.year1Risk, 2.1)
//        let pt2 = ArvcRiskModel(sex: 0, age: 60, hxSyncope: 0, hxNSVT: 1, pvcCount: 11180, twiCount: 4, rvef: 44)
//        let result2 = pt2.ltvaCalculateRisk()
//        XCTAssertEqual(result2.year5Risk, 9.1)
//        XCTAssertEqual(result2.year2Risk, 6.2)
//        XCTAssertEqual(result2.year1Risk, 3.8)
//        let pt3 = ArvcRiskModel(sex: 1, age: 49, hxSyncope: 0, hxNSVT: 1, pvcCount: 28948, twiCount: 5, rvef: 35)
//        let result3 = pt3.ltvaCalculateRisk()
//        XCTAssertEqual(result3.year5Risk, 9.9)
//        XCTAssertEqual(result3.year2Risk, 45.8)
//        XCTAssertEqual(result3.year1Risk, 31.4)
//    }
}
