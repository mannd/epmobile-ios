//
//  TestV2TransitionCalculator.swift
//  EP MobileTests
//
//  Created by David Mann on 5/28/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class TestV2TransitionCalculator: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testCalculate() {
        let calculator = V2TransitionCalculator()
        XCTAssertNil(calculator.calculate())
        let params1 = V2TransitionParameters(rVT: 1, sVT: 1, rSR: 1, sSR: 1)
        XCTAssertEqual(1, calculator.calculate(parameters: params1))
        let params2 = V2TransitionParameters(rVT: 13, sVT: 40, rSR: 33, sSR: 70)
        XCTAssertEqual(0.77, calculator.calculate(parameters: params2)!, accuracy: 0.01)
        // if negative params sneak in, make them positive
        let params3 = V2TransitionParameters(rVT: 13, sVT: -40, rSR: 33, sSR: -70)
        XCTAssertEqual(0.77, calculator.calculate(parameters: params3)!, accuracy: 0.01)
        // don't allow all zeros
        let params4 = V2TransitionParameters(rVT: 0, sVT: 0, rSR: 0, sSR: 0)
        XCTAssertNil(calculator.calculate(parameters: params4))
        // but allow R or S to be zero
        let params5 = V2TransitionParameters(rVT: 0, sVT: 40, rSR: 30, sSR: 100)
        XCTAssertEqual(0, calculator.calculate(parameters: params5))
        // but don't allow SR ratio both to be zero
        let params6 = V2TransitionParameters(rVT: 10, sVT: 40, rSR: 0, sSR: 100)
        XCTAssertNil(calculator.calculate(parameters: params6))
    }


}
