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
        XCTAssertEqual(try h12.calculate(), 0.0114, accuracy: 0.001)
        let h13 = HcmModel(age: 36, thickness: 20, laDiameter: 51, gradient: 50, familyHxScd: true, hxNsvt: true, hxSyncope:  true)
        XCTAssertEqual(try h13.calculate(), 0.2375, accuracy: 0.001)
        let h14 = HcmModel(age: 36, thickness: 20, laDiameter: 51, gradient: 50, familyHxScd: false, hxNsvt: false, hxSyncope:  false)
        XCTAssertEqual(try h14.calculate(), 0.0360, accuracy: 0.001)
        let h15 = HcmModel(age: 35, thickness: 35, laDiameter: 51, gradient: 50, familyHxScd: false, hxNsvt: false, hxSyncope:  false)
        XCTAssertNoThrow(try h15.calculate())
    }

    func testHCMViewModel() {
        let h1 = HcmViewModel(age: 0, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h1.calculate(), "INVALID ENTRY")
        let h2 = HcmViewModel(age: 1, thickness: 0, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h2.calculate(), "INVALID ENTRY")
        let h3 = HcmViewModel(age: 1, thickness: 1, laDiameter: 0, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h3.calculate(), "INVALID ENTRY")
        let h4 = HcmViewModel(age: 1, thickness: 1, laDiameter: 1, gradient: 0, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h4.calculate(), "INVALID ENTRY")
        let h5 = HcmViewModel(age: 1, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h5.calculate(), "Age must be between 16 and 115 years.")
        let h6 = HcmViewModel(age: 116, thickness: 1, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h6.calculate(), "Age must be between 16 and 115 years.")
        let h7 = HcmViewModel(age: 115, thickness: 9, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h7.calculate(), "Maximum LV wall thickness must be between 10 and 35 mm.")
        let h8 = HcmViewModel(age: 115, thickness: 36, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h8.calculate(), "Maximum LV wall thickness must be between 10 and 35 mm.")
        let h9 = HcmViewModel(age: 115, thickness: 30, laDiameter: 1, gradient: 1, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h9.calculate(), "Maximum LA diameter must be between 28 and 67 mm.")
        let h10 = HcmViewModel(age: 115, thickness: 30, laDiameter: 1, gradient: 155, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h10.calculate(), "Maximum LA diameter must be between 28 and 67 mm.")
        let h11 = HcmViewModel(age: 115, thickness: 30, laDiameter: 1, gradient: 155, familyHxScd: true, hxNsvt: true, hxSyncope: true)
        XCTAssertEqual(h11.calculate(), "Maximum LA diameter must be between 28 and 67 mm.")

        let h12 = HcmViewModel(age: 30, thickness: 30, laDiameter: 30, gradient: 30, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h12.calculate(), "5 year SCD Risk = 2.4%\nICD generally not indicated.")
        let h13 = HcmViewModel(age: 30, thickness: 30, laDiameter: 30, gradient: 30, familyHxScd: true, hxNsvt: false, hxSyncope: false)
        XCTAssertEqual(h13.calculate(), "5 year SCD Risk = 3.8%\nICD generally not indicated.")
        let h14 = HcmViewModel(age: 30, thickness: 30, laDiameter: 30, gradient: 30, familyHxScd: true, hxNsvt: true, hxSyncope: false)
        XCTAssertEqual(h14.calculate(), "5 year SCD Risk = 8.5%\nICD should be considered.")
        let h15 = HcmViewModel(age: 30, thickness: 30, laDiameter: 30, gradient: 30, familyHxScd: true, hxNsvt: true, hxSyncope: true)
        XCTAssertEqual(h15.calculate(), "5 year SCD Risk = 16.6%\nICD should be considered.")
        XCTAssertEqual(h15.getDetails(), "Risk score: HCM SCD 2014\nRisks:\nAge = 30 yrs\nMax LV wall thickness = 30 mm\nMax LA diameter = 30 mm\nMax LVOT gradient = 30 mmHg\nFamily hx of SCD\nHx of NSVT\nHx of unexplained syncope\n5 year SCD Risk = 16.6%\nICD should be considered.\nReference: O’Mahony C., Jichi F., Pavlou M., Monserrat L., Anastasakis A., Rapezzi C.  A novel clinical risk prediction model for sudden cardiac death in hypertrophic cardiomyopathy (HCM Risk-SCD). Eur Heart J [Internet] 2014 Aug [cited 2015 May 29];35(30):2010–2020. Available from: http://doi.org/10.1093/eurheartj/eht439")
        let h16 = HcmViewModel(age: 115, thickness: 30, laDiameter: 51, gradient: 155, familyHxScd: true, hxNsvt: true, hxSyncope: true)
        XCTAssertEqual(h16.calculate(), "Maximum LV outflow tract gradient must be between 2 and 154 mmHg")
    }
}
