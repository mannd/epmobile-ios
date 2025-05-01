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
        let bmi = try BmiModel(height: Measurement(value: 180.0, unit: .centimeters), weight: Measurement(value: 70.0, unit: .kilograms))
        #expect(bmi.calculate().isApproximatelyEqual(to: 21.6, absoluteTolerance: 0.05))
        let bmi1 = try BmiModel(height: Measurement(value: 72.0, unit: .inches), weight: Measurement(value: 155.0, unit: .pounds))
        #expect(bmi1.calculate().isApproximatelyEqual(to: 21.0, absoluteTolerance: 0.05))
        #expect(throws: BmiError.invalidParameter) { try BmiModel(height: Measurement(value: 180.0, unit: .centimeters), weight: Measurement(value: 0.0, unit: .kilograms))
        }
        #expect(throws: BmiError.invalidParameter) { try BmiModel(height: Measurement(value: 0, unit: .centimeters), weight: Measurement(value: 0.0, unit: .kilograms))
        }
    }

    @Test
    func testRounding() async throws {
        #expect(BmiModel.rounded(22.45) == "22.5")
        #expect(BmiModel.rounded(22.44) == "22.4")
        #expect(BmiModel.rounded(21.99) == "22.0")
        #expect(BmiModel.rounded(22.04) == "22.0")
        #expect(BmiModel.rounded(22.49) == "22.5")

    }

}
