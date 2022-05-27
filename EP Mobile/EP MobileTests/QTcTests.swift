//
//  QTcTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/1/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

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

    func testFormattedQTcResult() {
        XCTAssertEqual(QTcCalculatorViewModel.formattedQTcResult(rawResult: 111.50), "QTc = 112 msec")
        XCTAssertEqual(QTcCalculatorViewModel.formattedQTcResult(rawResult: 111.49), "QTc = 111 msec")
    }

    func testQTcCalculatorViewModel() {
        let qtMeasurement1 = QtMeasurement(qt: nil, intervalRate: 100, units: .msec, intervalRateType: .interval)
        let qtcVM1 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement1, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM1.calculate().qtc, ErrorMessage.invalidEntry)
        let qtMeasurement2 = QtMeasurement(qt: 0, intervalRate: 100, units: .msec, intervalRateType: .interval)
        let qtcVM2 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement2, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM2.calculate().qtc, ErrorMessage.invalidEntry)
        let qtMeasurement3 = QtMeasurement(qt: 400, intervalRate: 600, units: .msec, intervalRateType: .interval)
        let qtcVM3 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement3, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM3.calculate().qtc, "QTc = 516 msec")
        XCTAssertEqual(qtcVM3.calculate().flagResult, true)
        let qtMeasurement4 = QtMeasurement(qt: 300, intervalRate: 800, units: .msec, intervalRateType: .interval)
        let qtcVM4 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement4, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM4.calculate().qtc, "QTc = 335 msec")
        XCTAssertEqual(qtcVM4.calculate().flagResult, false)
        let qtMeasurement5 = QtMeasurement(qt: 300, intervalRate: 60, units: .msec, intervalRateType: .rate)
        let qtcVM5 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement5, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM5.calculate().qtc, "QTc = 300 msec")
        let qtMeasurement6 = QtMeasurement(qt: 300, intervalRate: 90, units: .msec, intervalRateType: .rate)
        let qtcVM6 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement6, formula: .qtcHdg, maximumQTc: 440)
        XCTAssertEqual(qtcVM6.calculate().qtc, "QTc = 353 msec")
    }

    func testQTcCalculatorRanges() {
        let qtMeasurement1 = QtMeasurement(qt: 199, intervalRate: 90, units: .msec, intervalRateType: .rate)
        let qtcVM1 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement1, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM1.calculate().qtc, ErrorMessage.outOfRange)
        let qtMeasurement2 = QtMeasurement(qt: 300, intervalRate: 10, units: .msec, intervalRateType: .interval)
        let qtcVM2 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement2, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM2.calculate().qtc, ErrorMessage.outOfRange)
        let qtMeasurement3 = QtMeasurement(qt: 801, intervalRate: 600, units: .msec, intervalRateType: .interval)
        let qtcVM3 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement3, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM3.calculate().qtc, ErrorMessage.outOfRange)
        let qtMeasurement4 = QtMeasurement(qt: 401, intervalRate: 600, units: .msec, intervalRateType: .interval)
        let qtcVM4 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement4, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertNotEqual(qtcVM4.calculate().qtc, ErrorMessage.outOfRange)
        let qtMeasurement5 = QtMeasurement(qt: nil, intervalRate: 600, units: .msec, intervalRateType: .interval)
        let qtcVM5 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement5, formula: .qtcBzt, maximumQTc: 440)
        XCTAssert(qtcVM5.valuesOutOfRange())
        let qtMeasurement6 = QtMeasurement(qt: nil, intervalRate: 600, units: .msec, intervalRateType: .interval)
        let qtcVM6 = QTcCalculatorViewModel(qtMeasurement: qtMeasurement6, formula: .qtcBzt, maximumQTc: 440)
        XCTAssertEqual(qtcVM6.calculate().qtc, ErrorMessage.invalidEntry)
    }
}
