//
//  QTcIvcdTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/5/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile
@testable import MiniQTc

class QTcIvcdTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQTcIvcdModel() {
        let qtcIvcd = QTcIvcd(qt: 360, qrs: 130, rr: 880, sex: .male)
        XCTAssertEqual(qtcIvcd.qt, 360.0, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.jt(), 230.0, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.jtc()!, 253.76, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.qtCorrectedForLBBB(), 296.95, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.preLbbbQtc()!, 348.76, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.qtc()!, 383.76, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.qtm(), 296.95, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.qtmc()!, 316.54, accuracy: 0.01)
        XCTAssertEqual(qtcIvcd.qtCorrectedForIvcdAndSex(), 364.97, accuracy: 0.01)
    }

    func testQTcIvcdViewModel() {
        let qtcIvcdViewModel = QTcIvcdViewModel(qt: 360, qrs: 130, intervalRate: 880, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: true)
        let result = try! qtcIvcdViewModel.calculate()
        XCTAssertEqual(result[.qt], "QT = 360 msec")
        XCTAssertEqual(result[.jt], "JT = 230 msec")
        XCTAssertEqual(result[.qtc], "QTc = 384 msec")
        XCTAssertEqual(result[.jtc], "JTc = 254 msec")
        XCTAssertEqual(result[.qtm], "QTm = 297 msec")
        XCTAssertEqual(result[.qtmc], "QTmc = 317 msec")
        XCTAssertEqual(result[.qtrrqrs], "QTrr,qrs = 365 msec")
        XCTAssertEqual(result[.prelbbbqtc], "preLBBBQTc = 349 msec")

        let qtcIvcdViewModel1 = QTcIvcdViewModel(qt: 360, qrs: 130, intervalRate: 880, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        let result1 = try! qtcIvcdViewModel1.calculate()
        XCTAssertEqual(result1[.qtm], "QTm only defined for LBBB")
        XCTAssertEqual(result1[.qtmc], "QTmc only defined for LBBB")
        XCTAssertEqual(result1[.prelbbbqtc], "preLBBBQTc only defined for LBBB")


        let qtcIvcdViewModel2 = QTcIvcdViewModel(qt: 0, qrs: 150, intervalRate: 500, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        XCTAssertThrowsError(try qtcIvcdViewModel2.calculate())
        let qtcIvcdViewModel3 = QTcIvcdViewModel(qt: 400, qrs: 0, intervalRate: 500, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        XCTAssertThrowsError(try qtcIvcdViewModel3.calculate())
        let qtcIvcdViewModel4 = QTcIvcdViewModel(qt: 300, qrs: 150, intervalRate: 0, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        XCTAssertThrowsError(try qtcIvcdViewModel4.calculate())

        // QRS too short
        let qtcIvcdViewModel5 = QTcIvcdViewModel(qt: 300, qrs: 119, intervalRate: 500, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        XCTAssertThrowsError(try qtcIvcdViewModel5.calculate())

        // QRS too long
        let qtcIvcdViewModel6 = QTcIvcdViewModel(qt: 300, qrs: 301, intervalRate: 500, intervalRateType: .interval, sex: .male, formula: .qtcBzt, isLBBB: false)
        XCTAssertThrowsError(try qtcIvcdViewModel6.calculate())


    }

    // These are the old QTc IVCD calculator objc tests transcribed to Swift.
    func testCorrectQTForBBB() {
        let m1 = QTcIvcd(qt: 360, qrs: 144, intervalRate: 800, intervalRateType: .interval, sex: .male)
        let result1 = m1.qtCorrectedForLBBB()
        XCTAssertEqual(result1, 290.16, accuracy: 0.01)
        let m2 = QTcIvcd(qt: 444, qrs: 197, intervalRate: 800, intervalRateType: .interval, sex: .male)
        let result2 = m2.qtCorrectedForLBBB()
        XCTAssertEqual(result2, 348.45, accuracy: 0.01)
        let m3 = QTcIvcd(qt: 400, qrs: 0, intervalRate: 800, intervalRateType: .interval, sex: .male)
        let result3 = m3.qtCorrectedForLBBB()
        XCTAssertEqual(result3, 400, accuracy: 0.01)
    }

    func testCorrectJT() {
        let m1 = QTcIvcd(qt: 360, qrs: 135, intervalRate: 550, intervalRateType: .interval, sex: .male)
        let result1 = m1.jtc()!
        let qtc = m1.qtc()!
        XCTAssertEqual(result1, qtc - 135.0, accuracy: 0.01)
    }

    func testJT() {
        let m1 = QTcIvcd(qt: 398.4, qrs: 99.0, intervalRate: 800, intervalRateType: .interval, sex: .male)
        let result1 = m1.jt()
        XCTAssertEqual(result1, 398.4 - 99.0, accuracy: 0.01)
    }

    func testCorrectQTForBBBandSex() {
        let m1 = QTcIvcd(qt: 379, qrs: 155, intervalRate: 77, intervalRateType: .rate, sex: .male)
        let result1 = m1.qtCorrectedForIvcdAndSex()
        XCTAssertEqual(result1, 376.34, accuracy: 0.01)
        let m2 = QTcIvcd(qt: 442, qrs: 110, intervalRate: 55, intervalRateType: .rate, sex: .female)
        let result2 = m2.qtCorrectedForIvcdAndSex()
        XCTAssertEqual(result2, 420.87, accuracy: 0.01)
    }

    func testPreLbbbQTc() {
        let m1 = QTcIvcd(qt: 333, qrs: 166, intervalRate: 789, intervalRateType: .interval, sex: .male)
        let result1 = m1.preLbbbQtc()!
        XCTAssertEqual(result1, 303.89, accuracy: 0.01)
        let m2 = QTcIvcd(qt: 333, qrs: 166, intervalRate: 789, intervalRateType: .interval, sex: .female)
        let result2 = m2.preLbbbQtc()!
        XCTAssertEqual(result2, 296.89, accuracy: 0.01)
    }
}
