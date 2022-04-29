//
//  IntervalRateConversionTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import XCTest
@testable import EP_Mobile

class IntervalRateConversionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertValue() {
        var result = IntervalRateConversion.convert(value: 60)
        XCTAssertTrue(result == "1000")
        result = IntervalRateConversion.convert(value: 1000)
        XCTAssertTrue(result == "60")
        result = IntervalRateConversion.convert(value: 733)
        XCTAssertTrue(result == "82")
        result = IntervalRateConversion.convert(value: 0)
        XCTAssertNil(result)
        result = IntervalRateConversion.convert(value: -1)
        XCTAssertNil(result)
    }

}
