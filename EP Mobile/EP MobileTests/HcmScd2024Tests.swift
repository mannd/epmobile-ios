//
//  HcmScd2024Tests.swift
//  EP MobileTests
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Testing
@testable import EP_Mobile

struct HcmScd2024Tests {

    @Test func testHcmScd2024Model() async throws {
        let h1 = HcmScd2024Model(familyHxScd: true)
        #expect(h1.calculate() == Recommendation.class2a)
        let h2 = HcmScd2024Model()
        #expect(h2.calculate() == Recommendation.class3)
        let h3 = HcmScd2024Model(massiveLVH: true)
        #expect(h3.calculate() == Recommendation.class2a)
        let h4 = HcmScd2024Model(familyHxScd: true, massiveLVH: true)
        #expect(h4.calculate() == Recommendation.class2a)
        let h5 = HcmScd2024Model(lowLVEF: true)
        #expect(h5.calculate() == Recommendation.class2a)
        let h6 = HcmScd2024Model(hxNsvt: true)
        #expect(h6.calculate() == Recommendation.class2b)
        let h7 = HcmScd2024Model(extensiveLGE: true)
        #expect(h7.calculate() == Recommendation.class2b)
    }

}
