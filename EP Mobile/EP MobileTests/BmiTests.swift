//
//  BmiTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/1/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Testing
import Numerics
@testable import EP_Mobile

struct BmiTests {

    @Test func testCalculate() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let bmi = BmiModel(height: Measurement(value: 180.0, unit: .centimeters), weight: Measurement(value: 70.0, unit: .kilograms))
        #expect(bmi.calculate().isApproximatelyEqual(to: 21.6, absoluteTolerance: 0.01))
    }

}
