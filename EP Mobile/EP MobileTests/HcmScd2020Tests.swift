//
//  HcmScd2020Tests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

struct HcmScd2020Tests {

    @Test func testHcmScd2020Model() async throws {
        let h1 = HcmScd2020Model(familyHxScd: true)
        #expect(h1.calculate() == Recommendation.class2a)
        let h2 = HcmScd2020Model()
        #expect(h2.calculate() == Recommendation.class3)
        let h3 = HcmScd2020Model(massiveLVH: true)
        #expect(h3.calculate() == Recommendation.class2a)
        let h4 = HcmScd2020Model(familyHxScd: true, massiveLVH: true)
        #expect(h4.calculate() == Recommendation.class2a)
        let h5 = HcmScd2020Model(lowLVEF: true)
        #expect(h5.calculate() == Recommendation.class2a)
        let h6 = HcmScd2020Model(hxNsvt: true)
        #expect(h6.calculate() == Recommendation.class2b)
        let h7 = HcmScd2020Model(extensiveLGE: true)
        #expect(h7.calculate() == Recommendation.class2b)
    }

}
