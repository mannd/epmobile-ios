//
//  DrugTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class DrugTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testApixaban() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.5)
        let drug = DrugFactory.create(drugName: .apixaban, patient: patient)!
        XCTAssertEqual(drug.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
    }

    func testDabigatran() {
        let p1 = try! Patient(age: 40, sex: .male, weight: 70, massUnits: .lb, creatinine: 1.0, concentrationUnits: .mgDL)
        let drug = DrugFactory.create(drugName: .dabigatran, patient: p1)
        XCTAssertEqual(drug?.getDose(), "Dose = 150 mg BID. \nConsider reducing dose to 75 mg BID when using with dronedarone or systemic ketoconazole.")
    }
}
