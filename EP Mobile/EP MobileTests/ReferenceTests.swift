//
//  ReferenceTests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class ReferenceTests: XCTestCase {

    func testReferences() {
        let ref1 = Reference("GarbageStuff")
        // a ref without a link is ok, some old refs don't have links...
        XCTAssertEqual(ref1!.text, "GarbageStuff")
        XCTAssertEqual(ref1!.link, "")
        let ref2 = Reference("Real reference.  doi:x.y.z")
        XCTAssertEqual(ref2!.text, "Real reference.")
        XCTAssertEqual(ref2!.link, "doi:x.y.z")
        XCTAssertEqual(ref2!.getReferenceWithMarkdownLink(), "Real reference.\n[doi:x.y.z](https://doi.org/x.y.z)")
        let ref3 = Reference("Another real reference. https://www.google.com")
        XCTAssertEqual(ref3!.text, "Another real reference.")
        XCTAssertEqual(ref3!.link, "https://www.google.com")
        XCTAssertEqual(ref3!.getReferenceWithMarkdownLink(), "Another real reference.\nhttps://www.google.com")
        // Let's try a real reference
        let ref4 = Reference("Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510.\ndoi:10.1093/eurheartj/ehr488")
        XCTAssertEqual(ref4!.text, "Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510.")
        XCTAssertEqual(ref4!.link, "doi:10.1093/eurheartj/ehr488")
        XCTAssertEqual(ref4!.getPlainTextReference(), "Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510.\ndoi:10.1093/eurheartj/ehr488")
        XCTAssertEqual(ref4!.getReferenceWithMarkdownLink(), "Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510.\n[doi:10.1093/eurheartj/ehr488](https://doi.org/10.1093/eurheartj/ehr488)")
        let ref5 = Reference("Horton J, Bushwick B: American Family Physician. Feb 1, 1999. https://www.aafp.org/afp/1999/0201/p635.html")
        XCTAssertEqual(ref5!.getReferenceWithMarkdownLink(), ref5!.getPlainTextReference())
        // What about a link and no reference?
        let ref6 = Reference("doi:123.456")
        XCTAssertEqual(ref6!.text, "")
        XCTAssertEqual(ref6!.link, "doi:123.456")
        XCTAssertEqual(ref6!.getReferenceWithMarkdownLink(), "\n[doi:123.456](https://doi.org/123.456)")
    }

}
