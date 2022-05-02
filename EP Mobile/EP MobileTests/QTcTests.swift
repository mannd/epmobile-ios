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


class QTcTests: XCTestCase {
    let qtcFactory = QTcFormulaFactory()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBazett() {
        let qtcBzt = qtcFactory.create(name: .bazett)
        let m1 = QTMeasurement(qt: 300, rr: 1000)
        XCTAssertEqual(qtcBzt.calculate(qtMeasurement: m1), 300, accuracy: 0.01)
//        XCTAssertEqual(try! qtcBzt.calculate(qtInSec:0.3, rrInSec:1.0), 0.3, accuracy: delta)
//        XCTAssertEqual(try! qtcBzt.calculate(qtInMsec:300, rrInMsec:1000), 300, accuracy:delta)
//        XCTAssertEqual(try! qtcBzt.calculate(qtInSec: 0.3, rate: 60), 0.3, accuracy: delta)
//        XCTAssertEqual(try! qtcBzt.calculate(qtInMsec: 300, rate: 60), 300, accuracy: delta)
    }

}
