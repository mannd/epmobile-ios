//
//  QTcTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/1/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import XCTest
@testable import EP_Mobile
@testable import MiniQTc


class QTcTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMiniQTc() {
        let formula: Formula = .qtcBzt
        let calculator = QTc.qtcCalculator(formula: formula)
        let measurement = QtMeasurement(qt: 400, intervalRate: 1000, units: .msec, intervalRateType: .interval)
        let result = try! calculator.calculate(qtMeasurement: measurement)
        XCTAssertEqual(result, 400, accuracy: 0.0001)
    }

}
