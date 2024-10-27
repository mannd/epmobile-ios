//
//  HcmScd2022Tests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

struct HcmScd2022Tests {

    @Test func testHcmRiskScd() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let model1 = HcmRiskScdModel(age: 10, thickness: 10, laDiameter: 28, gradient: 2, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        #expect(throws: HcmRiskScdError.ageOutOfRange) {
            try model1.calculate()
        }
        let model2 = HcmRiskScdModel(age: 20, thickness: 10, laDiameter: 28, gradient: 2, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        let risk2 = try! model2.calculate()
        #expect(abs(risk2) - 0.0106 < 0.0001)
    }

    @Test func testHcmScd2022() async throws {
        let model1 = HcmRiskScdModel(age: 20, thickness: 10, laDiameter: 28, gradient: 2, familyHxScd: false, hxNsvt: false, hxSyncope: false)
        let model2 = HcmScd2022Model(apicalAneurysm: true, riskSCDModel: model1)
        let risk2 = try! model2.calculate()
        #expect(abs(risk2.0) - 0.0106 < 0.0001)
        #expect(risk2.1 == .class2b)
        // test calculations based on HCM Risk-SCD results.
        let model3 = HcmScd2022Model()
        let risk3 = model3.calculate(scdProbability: 0)
        #expect(risk3.0 == 0)
        #expect(risk3.1 == .class3)
        let model4 = HcmScd2022Model(apicalAneurysm: true)
        let risk4 = model4.calculate(scdProbability: 0)
        #expect(risk4.0 == 0)
        #expect(risk4.1 == .class2b)
        let model5 = HcmScd2022Model(extensiveLGE: true)
        let risk5 = model5.calculate(scdProbability: 0)
        #expect(risk5.0 == 0)
        #expect(risk5.1 == .class2b)
        let model6 = HcmScd2022Model(lowLVEF: true)
        let risk6 = model6.calculate(scdProbability: 0)
        #expect(risk6.0 == 0)
        #expect(risk6.1 == .class2b)
        let model7 = HcmScd2022Model()
        let risk7 = model7.calculate(scdProbability: 0.04)
        #expect(risk7.0 == 0.04)
        #expect(risk7.1 == .class2b)
        let model8 = HcmScd2022Model()
        let risk8 = model8.calculate(scdProbability: 0.0399)
        #expect(risk8.0 == 0.0399)
        #expect(risk8.1 == .class3)
        let model9 = HcmScd2022Model()
        let risk9 = model9.calculate(scdProbability: 0.05)
        #expect(risk9.0 == 0.05)
        #expect(risk9.1 == .class2b)
        let model10 = HcmScd2022Model(abnormalBP: true)
        let risk10 = model10.calculate(scdProbability: 0.05)
        #expect(risk10.0 == 0.05)
        #expect(risk10.1 == .class2a)
        let model11 = HcmScd2022Model(lowLVEF: true)
        let risk11 = model11.calculate(scdProbability: 0.05)
        #expect(risk11.0 == 0.05)
        #expect(risk11.1 == .class2a)
        let model12 = HcmScd2022Model(sarcomericMutation: true)
        let risk12 = model12.calculate(scdProbability: 0.02)
        #expect(risk12.0 == 0.02)
        #expect(risk12.1 == .class3)
        let model13 = HcmScd2022Model(abnormalBP: true, sarcomericMutation: true)
        let risk13 = model13.calculate(scdProbability: 0.02)
        #expect(risk13.0 == 0.02)
        #expect(risk13.1 == .class3)
        let model14 = HcmScd2022Model(lowLVEF: true,abnormalBP: true, sarcomericMutation: true)
        let risk14 = model14.calculate(scdProbability: 0.02)
        #expect(risk14.0 == 0.02)
        #expect(risk14.1 == .class2b)
    }

    @Test(arguments: [
        HcmScd2022Model(apicalAneurysm: true),
        HcmScd2022Model(lowLVEF: true),
        HcmScd2022Model(extensiveLGE: true)
    ] )
    func testHcmScd2022Class2b(model: HcmScd2022Model) {
        let result = model.calculate(scdProbability: 0.03)
        #expect (result.0 == 0.03)
        #expect(result.1 == .class2b)
    }

    @Test(arguments: [
        HcmScd2022Model(apicalAneurysm: true),
        HcmScd2022Model(lowLVEF: true),
        HcmScd2022Model(extensiveLGE: true),
        HcmScd2022Model(abnormalBP: true),
        HcmScd2022Model(sarcomericMutation: true)
    ])
    func testHcmScd2022Class2a(model: HcmScd2022Model) {
        let result = model.calculate(scdProbability: 0.05)
        #expect (result.0 == 0.05)
        #expect(result.1 == .class2a)
    }

    @Test(arguments: [
        HcmScd2022Model(),
        HcmScd2022Model(apicalAneurysm: true),
        HcmScd2022Model(lowLVEF: true),
        HcmScd2022Model(extensiveLGE: true),
        HcmScd2022Model(abnormalBP: true),
        HcmScd2022Model(sarcomericMutation: true)
    ])
    func testHcmScd2022Class2aWithHighRisk(model: HcmScd2022Model) {
        let result = model.calculate(scdProbability: 0.08)
        #expect (result.0 == 0.08)
        #expect(result.1 == .class2a)
    }

    @Test(arguments: [
        HcmScd2022Model(apicalAneurysm: true),
        HcmScd2022Model(lowLVEF: true),
        HcmScd2022Model(extensiveLGE: true),
    ])
    func testHcmScd2022Class2aWithLowRisk(model: HcmScd2022Model) {
        let result = model.calculate(scdProbability: 0.02)
        #expect (result.0 == 0.02)
        #expect(result.1 == .class2b)
    }

    @Test(arguments: [
        HcmScd2022Model(),
        HcmScd2022Model(abnormalBP: true),
        HcmScd2022Model(sarcomericMutation: true)
    ])
    func testHcmScd2022Class2aWithLowestRisk(model: HcmScd2022Model) {
        let result = model.calculate(scdProbability: 0.02)
        #expect (result.0 == 0.02)
        #expect(result.1 == .class3)
    }
}
