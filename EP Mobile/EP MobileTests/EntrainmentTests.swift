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
    }

}
