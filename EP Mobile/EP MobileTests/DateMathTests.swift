//
//  DateMathTests.swift
//  EP MobileTests
//
//  Created by David Mann on 4/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import XCTest
@testable import EP_Mobile

class DateMathTests: XCTestCase {

    func testAddDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.date(from: "2022/01/01")!
        let result1 = DateMath.addDays(startingDate: startDate, days: 0, subtractDays: false)
        XCTAssertEqual(result1, "Jan 1, 2022")
        let result2 = DateMath.addDays(startingDate: startDate, days: 365, subtractDays: false)
        XCTAssertEqual(result2, "Jan 1, 2023")
        let result3 = DateMath.addDays(startingDate: startDate, days: 1, subtractDays: false)
        XCTAssertEqual(result3, "Jan 2, 2022")
        let result4 = DateMath.addDays(startingDate: startDate, days: 1, subtractDays: true)
        XCTAssertEqual(result4, "Dec 31, 2021")
        let result5 = DateMath.addDays(startingDate: startDate, days: 90, subtractDays: false)
        XCTAssertEqual(result5, "Apr 1, 2022")
        let result6 = DateMath.addDays(startingDate: startDate, days: 90, subtractDays: true)
        XCTAssertEqual(result6, "Oct 3, 2021")
    }

}
