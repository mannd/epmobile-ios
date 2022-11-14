//
//  UnitTests.swift
//  EP MobileTests
//
//  Created by David Mann on 11/11/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class UnitTests: XCTestCase {
    func testTrimZeros() {
        let value = 3.345
        XCTAssertEqual(value.trimZeros(), "3.3")
        XCTAssertEqual(4.trimZeros(), "4")
        XCTAssertEqual(5.0.trimZeros(), "5")
        XCTAssertEqual(5.123.trimZeros(), "5.1")
    }
}
