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
        let e4 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: -1, egQrs: 260)
        XCTAssertNil(e4.similarSQrsEgQrs())
        let e5 = Entrainment(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 1, egQrs: -1)
        XCTAssertNil(e5.similarSQrsEgQrs())
    }

    func testEntrainmentViewModel() {
        let vm1 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm1.calculate(), "PPI-TCL = 20. Outer loop of reentry circuit.")
        let vm2 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm2.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit.")
        let vm3 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: 100, egQrs: 100)
        XCTAssertEqual(vm3.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit. Isthmus central site. Similar S-QRS and EG-QRS intervals suggest site in isthmus of reentry circuit.")
        let vm4 = EntrainmentViewModel(tcl: 200, ppi: 231, concealedFusion: false, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm4.calculate(), "PPI-TCL = 31. Remote site from reentry circuit.")
        let vm5 = EntrainmentViewModel(tcl: 200, ppi: 231, concealedFusion: true, sQrs: nil, egQrs: nil)
        XCTAssertEqual(vm5.calculate(), "PPI-TCL = 31. Adjacent bystander pathway not in reentry circuit." )
        let vm6 = EntrainmentViewModel(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 80, egQrs: nil)
        XCTAssertEqual(vm6.calculate(), "PPI-TCL = 29. Inner loop or isthmus site of reentry circuit. Isthmus exit site.")
        let vm7 = EntrainmentViewModel(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 100, egQrs: nil)
        XCTAssertEqual(vm7.calculate(), "PPI-TCL = 29. Inner loop or isthmus site of reentry circuit. Isthmus central site.")
        let vm8 = EntrainmentViewModel(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 151, egQrs: nil)
        XCTAssertEqual(vm8.calculate(), "PPI-TCL = 29. Inner loop or isthmus site of reentry circuit. Isthmus proximal site.")
        let vm9 = EntrainmentViewModel(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 299, egQrs: nil)
        XCTAssertEqual(vm9.calculate(), "PPI-TCL = 29. Inner loop or isthmus site of reentry circuit. Inner loop site.")
        let vm10 = EntrainmentViewModel(tcl: 300, ppi: 329, concealedFusion: true, sQrs: 301, egQrs: nil)
        XCTAssertEqual(vm10.calculate(), "Invalid S-QRS (>TCL) ignored!")
        let vm11 = EntrainmentViewModel(tcl: 0, ppi: 329, concealedFusion: true, sQrs: 301, egQrs: nil)
        XCTAssertEqual(vm11.calculate(), "INVALID ENTRY")
        let vm12 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: 0, egQrs: 200)
        XCTAssertEqual(vm12.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit. Isthmus exit site. Dissimilar S-QRS and EG-QRS intervals suggest site may be an adjacent bystander.")
        let vm13 = EntrainmentViewModel(tcl: 300, ppi: 310, concealedFusion: true, sQrs: 100, egQrs: 110)
        XCTAssertEqual(vm13.calculate(), "PPI-TCL = 10. Inner loop or isthmus site of reentry circuit. Isthmus central site. Similar S-QRS and EG-QRS intervals suggest site in isthmus of reentry circuit. Site has high chance of ablation success, if ablating VT.")
        let vm14 = EntrainmentViewModel(tcl: 300, ppi: 320, concealedFusion: true, sQrs: 1, egQrs: 200)
        XCTAssertEqual(vm14.calculate(), "PPI-TCL = 20. Inner loop or isthmus site of reentry circuit. Isthmus exit site. Dissimilar S-QRS and EG-QRS intervals suggest site may be an adjacent bystander.")
        let vm15 = EntrainmentViewModel(tcl: 300, ppi: 299, concealedFusion: true, sQrs: 1, egQrs: 200)
        XCTAssertEqual(vm15.calculate(), "PPI less than TCL.")
    }
}
