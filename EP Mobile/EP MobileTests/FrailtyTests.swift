//
//  FrailtyTests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class FrailtyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEntryValidation() throws {
        var frailty = FrailtyModel()
        frailty.fitness.value = 10
        XCTAssertNoThrow(try frailty.validateEntries())
        frailty.fitness.value = 11
        XCTAssertThrowsError(try frailty.validateEntries())
        frailty.fitness.value = 10
        frailty.feelNervous.value = 2
        XCTAssertNoThrow(try frailty.validateEntries())
    }

    func testCalculate() {
        var frailty = FrailtyModel()
        var result = frailty.calculate()
        XCTAssertEqual(1, result)
        frailty.fitness.value = 10
        result = frailty.calculate()
        XCTAssertEqual(0, result)
        // sometimesNoRule
        frailty.poorMemory.value = 0
        result = frailty.calculate()
        XCTAssertEqual(0, result)
        frailty.poorMemory.value = 1  // sometimes == no
        result = frailty.calculate()
        XCTAssertEqual(0, result)
        frailty.poorMemory.value = 2
        result = frailty.calculate()
        XCTAssertEqual(1, result)
        // sometimesYesRule
        frailty.feelNervous.value = 0
        result = frailty.calculate()
        XCTAssertEqual(1, result)
        frailty.feelNervous.value = 1
        result = frailty.calculate()
        XCTAssertEqual(2, result)  // sometimes == yes
        frailty.feelNervous.value = 2
        result = frailty.calculate()
        XCTAssertEqual(2, result)
        // yesNoRule
        frailty.shopping.value = 1
        result = frailty.calculate()
        XCTAssertEqual(3, result)
    }
}
