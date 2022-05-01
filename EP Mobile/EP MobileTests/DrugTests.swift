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
    var ptCC136: Patient!
    var ptCC68: Patient!
    var ptCC45: Patient!
    var ptCC34: Patient!
    var ptCC27: Patient!
    var ptCC19: Patient!
    var ptCC15: Patient!
    var ptCC14: Patient!

    var ptAge80Wt60Cr1: Patient!
    var ptAge80Wt60Cr1_5: Patient!
    var ptAge90Wt70: Patient!
    var ptAge90Wt50: Patient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ptCC136 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 0.5)
        ptCC68 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        ptCC45 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 1.5)
        ptCC34 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 2.0)
        ptCC27 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 2.5)
        ptCC19 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 3.5)
        ptCC15 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 4.5)
        ptCC14 = try! Patient(age: 70, sex: .male, weightKg: 70, creatinineMgDL: 4.8)
        ptAge80Wt60Cr1 = try! Patient(age: 80, sex: .male, weightKg: 60, creatinineMgDL: 1.0)
        ptAge80Wt60Cr1_5 = try! Patient(age: 80, sex: .male, weightKg: 60, creatinineMgDL: 1.5)
        ptAge90Wt70 = try! Patient(age: 90, sex: .male, weightKg: 70, creatinineMgDL: 1.0)
        ptAge90Wt50 = try! Patient(age: 90, sex: .male, weightKg: 50, creatinineMgDL: 1.0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ptCC136 = nil
        ptCC68 = nil
        ptCC34 = nil
        ptCC45 = nil
        ptCC27 = nil
        ptCC19 = nil
        ptCC15 = nil
        ptCC14 = nil
        ptAge80Wt60Cr1 = nil
        ptAge80Wt60Cr1_5 = nil
        ptAge90Wt70 = nil
        ptAge90Wt50 = nil
    }

    func testCreatinineClearances() {
        XCTAssertEqual(ptCC136.crCl, 136, accuracy: 1)
        XCTAssertEqual(ptCC68.crCl, 68, accuracy: 1)
        XCTAssertEqual(ptCC34.crCl, 34, accuracy: 1)
        XCTAssertEqual(ptCC45.crCl, 45, accuracy: 1)
        XCTAssertEqual(ptCC27.crCl, 27, accuracy: 1)
        XCTAssertEqual(ptCC19.crCl, 19, accuracy: 1)
        XCTAssertEqual(ptCC15.crCl, 15, accuracy: 1)
        XCTAssertEqual(ptCC14.crCl, 14, accuracy: 1)
    }


    func testApixaban() {
        let patient = try! Patient(age: 40, sex: .male, weightKg: 70, creatinineMgDL: 1.5)
        let drug = DrugFactory.create(drugName: .apixaban, patient: patient)!
        XCTAssertEqual(drug.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")

        let d68 = DrugFactory.create(drugName: .apixaban, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .apixaban, patient: ptCC45)
        let d34 = DrugFactory.create(drugName: .apixaban, patient: ptCC34)
        let d27 = DrugFactory.create(drugName: .apixaban, patient: ptCC27)
        let d19 = DrugFactory.create(drugName: .apixaban, patient: ptCC19)
        let d15 = DrugFactory.create(drugName: .apixaban, patient: ptCC15)
        let d14 = DrugFactory.create(drugName: .apixaban, patient: ptCC14)

        XCTAssertTrue(d14!.hasWarning())
        XCTAssertFalse(d15!.hasWarning())

        XCTAssertEqual(d68?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d45?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d34?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d27?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d19?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d15?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(d14?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).\nUse with caution in patients with ESRD on dialysis")

        let dAge80Wt60Cr1 = DrugFactory.create(drugName: .apixaban, patient: ptAge80Wt60Cr1)
        let dAge80Wt60Cr1_5 = DrugFactory.create(drugName: .apixaban, patient: ptAge80Wt60Cr1_5)
        XCTAssertEqual(dAge80Wt60Cr1?.getDose(), "Dose = 2.5 mg BID. Avoid coadministration with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(dAge80Wt60Cr1_5?.getDose(), "Dose = 2.5 mg BID. Avoid coadministration with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")

        let dAge90Wt70 = DrugFactory.create(drugName: .apixaban, patient: ptAge90Wt70)
        let dAge90Wt50 = DrugFactory.create(drugName: .apixaban, patient: ptAge90Wt50)
        XCTAssertEqual(dAge90Wt70?.getDose(), "Dose = 5 mg BID. Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")
        XCTAssertEqual(dAge90Wt50?.getDose(), "Dose = 2.5 mg BID. Avoid coadministration with strong dual inhibitors of CYP3A4 and P-gp (e.g. ketoconazole, itraconazole, ritonavir, clarithromycin).")


    }

    func testDabigatran() {
        let p1 = try! Patient(age: 40, sex: .male, weight: 70, massUnits: .lb, creatinine: 1.0, concentrationUnits: .mgDL)
        let drug = DrugFactory.create(drugName: .dabigatran, patient: p1)
        XCTAssertEqual(drug?.getDose(), "Dose = 150 mg BID.\nConsider reducing dose to 75 mg BID when using with dronedarone or systemic ketoconazole.")

        let d68 = DrugFactory.create(drugName: .dabigatran, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .dabigatran, patient: ptCC45)
        let d34 = DrugFactory.create(drugName: .dabigatran, patient: ptCC34)
        let d27 = DrugFactory.create(drugName: .dabigatran, patient: ptCC27)
        let d19 = DrugFactory.create(drugName: .dabigatran, patient: ptCC19)
        let d15 = DrugFactory.create(drugName: .dabigatran, patient: ptCC15)
        let d14 = DrugFactory.create(drugName: .dabigatran, patient: ptCC14)

        XCTAssertTrue(d45!.hasWarning())
        XCTAssertFalse(d68!.hasWarning())

        XCTAssertEqual(d68?.getDose(), "Dose = 150 mg BID.")
        XCTAssertEqual(d45?.getDose(), "Dose = 150 mg BID.\nConsider reducing dose to 75 mg BID when using with dronedarone or systemic ketoconazole.")
        XCTAssertEqual(d34?.getDose(), "Dose = 150 mg BID.\nConsider reducing dose to 75 mg BID when using with dronedarone or systemic ketoconazole.")
        XCTAssertEqual(d27?.getDose(), "Dose = 75 mg BID.\nAvoid concomitant use of P-gp inhibitors (e.g. dronedarone).")
        XCTAssertEqual(d19?.getDose(), "Dose = 75 mg BID.\nAvoid concomitant use of P-gp inhibitors (e.g. dronedarone).")
        XCTAssertEqual(d15?.getDose(), "Dose = 75 mg BID.\nAvoid concomitant use of P-gp inhibitors (e.g. dronedarone).")
        XCTAssertEqual(d14?.getDose(), "DO NOT USE!")
    }

    func testDofetilide() {
        let d68 = DrugFactory.create(drugName: .dofetilide, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .dofetilide, patient: ptCC45)
        let d34 = DrugFactory.create(drugName: .dofetilide, patient: ptCC34)
        let d27 = DrugFactory.create(drugName: .dofetilide, patient: ptCC27)
        let d19 = DrugFactory.create(drugName: .dofetilide, patient: ptCC19)

        XCTAssertTrue(d19!.hasWarning())
        XCTAssertFalse(d27!.hasWarning())

        XCTAssertEqual(d68?.getDose(), "Dose = 500 mcg BID.")
        XCTAssertEqual(d45?.getDose(), "Dose = 250 mcg BID.")
        XCTAssertEqual(d34?.getDose(), "Dose = 125 mcg BID.")
        XCTAssertEqual(d19?.getDose(), "DO NOT USE!")
    }

    func testEdoxaban() {
        let d136 = DrugFactory.create(drugName: .edoxaban, patient: ptCC136)
        let d68 = DrugFactory.create(drugName: .edoxaban, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .edoxaban, patient: ptCC45)
        let d15 = DrugFactory.create(drugName: .edoxaban, patient: ptCC15)
        let d14 = DrugFactory.create(drugName: .edoxaban, patient: ptCC14)

        XCTAssertTrue(d14!.hasWarning())
        XCTAssertFalse(d15!.hasWarning())
        XCTAssertTrue(d136!.hasWarning())

        XCTAssertEqual(d136?.getDose(), "DO NOT USE!\nEdoxaban should not be used in patients with CrCl > 95 mL/min")
        XCTAssertEqual(d68?.getDose(), "Dose = 60 mg daily.")
        XCTAssertEqual(d45?.getDose(), "Dose = 30 mg daily.")
        XCTAssertEqual(d15?.getDose(), "Dose = 30 mg daily.")
        XCTAssertEqual(d14?.getDose(), "DO NOT USE!")
    }

    func testRivaroxaban() {
        let d68 = DrugFactory.create(drugName: .rivaroxaban, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .rivaroxaban, patient: ptCC45)
        let d15 = DrugFactory.create(drugName: .rivaroxaban, patient: ptCC15)
        let d14 = DrugFactory.create(drugName: .rivaroxaban, patient: ptCC14)

        XCTAssertTrue(d14!.hasWarning())
        XCTAssertFalse(d15!.hasWarning())

        XCTAssertEqual(d68?.getDose(), "Dose = 20 mg daily. \nTake dose with evening meal.")
        XCTAssertEqual(d45?.getDose(), "Dose = 15 mg daily. \nTake dose with evening meal.")
        XCTAssertEqual(d15?.getDose(), "Dose = 15 mg daily. \nTake dose with evening meal.")
        XCTAssertEqual(d14?.getDose(), "DO NOT USE!")
    }

    func testSotalol() {
        let d68 = DrugFactory.create(drugName: .sotalol, patient: ptCC68)
        let d45 = DrugFactory.create(drugName: .sotalol, patient: ptCC45)
        let d14 = DrugFactory.create(drugName: .sotalol, patient: ptCC14)

        XCTAssertTrue(d14!.hasWarning())
        XCTAssertFalse(d45!.hasWarning())

        XCTAssertEqual(d68?.getDose(), "Dose = 80 mg BID. \nRecommended starting dose for treatment of atrial fibrillation. Initial QT should be < 450 msec. If QT remains < 500 msec dose can be increased to 120 mg or 160 mg BID.")
        XCTAssertEqual(d45?.getDose(), "Dose = 80 mg daily. \nRecommended starting dose for treatment of atrial fibrillation. Initial QT should be < 450 msec. If QT remains < 500 msec dose can be increased to 120 mg or 160 mg daily.")
        XCTAssertEqual(d14?.getDose(), "DO NOT USE!")
    }
}
