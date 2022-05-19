//
//  EntrainmentTests.swift
//  EP MobileTests
//
//  Created by David Mann on 5/16/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

class EntrainmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculate() {
        let e0 = Entrainment(tcl: 300, ppi: 299, concealedFusion: false, sQrs: 2, egQrs: 10)
        XCTAssertThrowsError(try e0.calculate())
        let e1 = Entrainment(tcl: 300, ppi: 0, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertThrowsError(try e1.calculate())
        let e2 = Entrainment(tcl: 0, ppi: 10, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertThrowsError(try e2.calculate())
        let e3 = Entrainment(tcl: 200, ppi: 230, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertEqual(try e3.calculate(), .outerLoop)
        let e4 = Entrainment(tcl: 200, ppi: 231, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertEqual(try e4.calculate(), .remoteSite)
        let e5 = Entrainment(tcl: 200, ppi: 231, concealedFusion: true, sQrs: nil, egQrs: nil)
        XCTAssertEqual(try e5.calculate(), .adjacentBystander)
        let e6 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 80, egQrs: nil)
        XCTAssertEqual(try e6.calculate(), .isthmusExit)
        let e7 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 100, egQrs: nil)
        XCTAssertEqual(try e7.calculate(), .isthmusCentral)
        let e8 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 151, egQrs: nil)
        XCTAssertEqual(try e8.calculate(), .isthmusProximal)
        let e9 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 299, egQrs: nil)
        XCTAssertEqual(try e9.calculate(), .innerLoop)
        let e10 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 301, egQrs: nil)
        XCTAssertThrowsError(try e10.calculate())
    }

    func testSimilarSQrsEgQrs() {
        let e1 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 301, egQrs: 321)
        XCTAssert(e1.similarSQrsEgQrs() == nil)
        let e2 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 280, egQrs: 259)
        XCTAssertFalse(e2.similarSQrsEgQrs()!)
        let e3 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 280, egQrs: 260)
        XCTAssert(e3.similarSQrsEgQrs()!)
    }

    func testEntrainmentViewModel() {
        let vm1 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm1.calculate(), "PPI-TCL = 20. Outer loop of reentry circuit.")
        let vm2 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm2.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit.")
        let vm3 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: 100, egQrs: 100)
        XCTAssertEqual(vm3.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit. Isthmus central site. Similar S-QRS and EG-QRS intervals suggest site in isthmus of reentry circuit.")
    }
}
