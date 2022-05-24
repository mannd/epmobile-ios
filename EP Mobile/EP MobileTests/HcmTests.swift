//
//  HcmTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class HcmTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHcmModel() {
        let h1 = HcmModel(age: 0, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h1.calculate())
        let h2 = HcmModel(age: 1, thickness: 0, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h2.calculate())
        let h3 = HcmModel(age: 1, thickness: 1, laDiameter: 0, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h3.calculate())
        let h4 = HcmModel(age: 1, thickness: 1, laDiameter: 1, gradient: 0, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h4.calculate())
        let h5 = HcmModel(age: 1, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h5.calculate())
        let h6 = HcmModel(age: 116, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h6.calculate())
        let h7 = HcmModel(age: 115, thickness: 9, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h7.calculate())
        let h8 = HcmModel(age: 115, thickness: 35, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h8.calculate())
        let h9 = HcmModel(age: 115, thickness: 30, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h9.calculate())
        let h10 = HcmModel(age: 115, thickness: 30, laDiameter: 1, gradient: 155, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertThrowsError(try h10.calculate())
        let h11 = HcmModel(age: 115, thickness: 34, laDiameter: 67, gradient: 154, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertNoThrow(try h11.calculate())
        let h12 = HcmModel(age: 16, thickness: 10, laDiameter: 28, gradient: 2, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertNoThrow(try h12.calculate())
        XCTAssertEqual(try h12.calculate(), 1.0)
    }

}
