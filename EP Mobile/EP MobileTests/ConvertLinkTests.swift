//
//  ConvertLinkTests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/8/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_Mobile

final class ConvertLinkTests: XCTestCase {

    // test link coversion as extension to String
    func testIsDoi() {
        let s1 = "https://www.google.com"
        XCTAssertFalse(s1.isDoi())
        let s2 = "doi:XXX.yyy.ZZZ"
        XCTAssert(s2.isDoi())
        let s3 = "DOI:XXX.yyy.ZZZ"
        XCTAssert(s3.isDoi())
        let s4 = "DOI:"
        XCTAssertFalse(s4.isDoi())
    }

    func testConvertDoiToLink() {
        let s1 = "xxxx"
        XCTAssertNil(s1.convertDoiToUri())
        let s2 = "doi:xxx.yyy/zzz"
        XCTAssertEqual(s2.convertDoiToUri(), "https://doi.org/xxx.yyy/zzz")
        let s3 = "https://XXXXX.com"
        XCTAssertEqual(s3.convertDoiToUri(), s3)
        let s4 = "doi:"
        XCTAssertNil(s4.convertDoiToUri())
        let s5 = "HTTP://XXXXX.com"
        XCTAssertEqual(s5.convertDoiToUri(), s5)
        let s6 = "DOI:xxx.YYY/zzz"
        XCTAssertEqual(s6.convertDoiToUri(), "https://doi.org/xxx.YYY/zzz")
    }

    func testGetMarkdownLink() {
        let s1 = "https://www.google.com"
        XCTAssertEqual(s1.getMarkdownLink(), s1)
        let s2 = "doi:xxx.yyy.zzz"
        XCTAssertEqual(s2.getMarkdownLink(), "[doi:xxx.yyy.zzz](https://doi.org/xxx.yyy.zzz)")
        let s3 = "xyz:Not-a-link"
        XCTAssertNil(s3.getMarkdownLink())
    }
}
