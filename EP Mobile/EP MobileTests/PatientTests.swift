//
//  DoseMathTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class PatientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMassConversions() {
        XCTAssertEqual(MassUnit.lbToKg(70), 31.7515, accuracy: 0.0001)
        XCTAssertEqual(MassUnit.kgToLb(31.7515), 70.0, accuracy: 0.0001)
    }

    func testConcentrationConversions() {
        XCTAssertEqual(ConcentrationUnit.mgDLToMmolL(2), 176.84, accuracy: 0.001)
        XCTAssertEqual(ConcentrationUnit.mmolLToMgDL(150), 1.696, accuracy: 0.001)
    }

    func testCreatinineClearance() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient.crCl, 97.2, accuracy: 0.1)
        let patient2 = try! Patient(age: 40, sex: .male, weight: 70, massUnits: .kg, creatinine: 1.0, concentrationUnits: .mgDL)
        XCTAssertEqual(patient2.crCl, 97.2, accuracy: 0.1)
        let patient3 = try! Patient(age: 50, sex: .female, weight: 170, massUnits: .lb, creatinine: 100, concentrationUnits: .mmolL)
        XCTAssertEqual(patient3.crCl, 72.4, accuracy: 0.1)
        let patient4 = try! Patient(age: 40, sex: .female, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient4.crCl, 82.6, accuracy: 0.1)
    }

    func testCrClResult() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient.crClResult(concentrationUnit: .mgDL), "Creatinine clearance = 97 mL/min")
        let patient4 = try! Patient(age: 50, sex: .female, weight: 120, massUnits: .lb, creatinine: 100, concentrationUnits: .mmolL)
        XCTAssertEqual(patient4.crClResult(concentrationUnit: .mgDL), "Creatinine clearance = 51 mL/min")
    }

    func testPatientErrors() {
        XCTAssertThrowsError(try Patient(age: 0, sex: .female, weightKg: 70, creatinineMgDL: 1.0))
        XCTAssertThrowsError(try Patient(age: 11, sex: .female, weightKg: 70, creatinineMgDL: 1.0))
        XCTAssertNoThrow(try Patient(age: 12, sex: .female, weightKg: 70, creatinineMgDL: 1.0))
        XCTAssertThrowsError(try Patient(age: 10, sex: .female, weightKg: 70, creatinineMgDL: 0))
        XCTAssertThrowsError(try Patient(age: 20, sex: .female, weightKg: 10, creatinineMgDL: 1.0))
        XCTAssertNoThrow(try Patient(age: 20, sex: .female, weightKg: 10.1, creatinineMgDL: 1.0))
        XCTAssertThrowsError(try Patient(age: 20, sex: .female, weightKg: 30, creatinineMgDL: 0))
        XCTAssertNoThrow(try Patient(age: 20, sex: .female, weightKg: 10.1, creatinineMgDL: 0.1))
    }

    func testGfr() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient.gfr, 93.7, accuracy: 0.1)
        let patient2 = try! Patient(age: 40, sex: .male, weight: 70, massUnits: .kg, creatinine: 1.0, concentrationUnits: .mgDL)
        XCTAssertEqual(patient2.gfr, 93.7, accuracy: 0.1)
        let patient3 = try! Patient(age: 50, sex: .female, weight: 170, massUnits: .lb, creatinine: 100, concentrationUnits: .mmolL)
        XCTAssertEqual(patient3.gfr, 56.6, accuracy: 0.1)
        let patient4 = try! Patient(age: 40, sex: .female, race: Race.black, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient4.gfr, 81.6, accuracy: 0.1)
    }

    func testGfrResult() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient.gfrResult(concentrationUnit: .mgDL), "GFR = 94 ml/min/1.73m²")
        let patient4 = try! Patient(age: 40, sex: .female, weightKg: 70, creatinineMgDL: 1.0)
        XCTAssertEqual(patient4.gfrResult(concentrationUnit: .mgDL), "GFR = 70 ml/min/1.73m²")
    }
}
