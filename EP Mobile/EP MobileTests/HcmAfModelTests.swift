import Testing
@testable import EP_Mobile

@Suite("HcmAfModel Tests")
struct HcmAfModelTests {
    // MARK: - getPoints() Tests

    @Test("getPoints() with valid inputs returns Success with correct score")
    func validPointsCalculation() async throws {
        // LA Diameter (40): (40-24)/6 = 2 -> 2*2+8 = 12
        // Age at Eval (50): (50-10)/10 = 4 -> 4*3+8 = 20
        // Age at Dx (35): 35/10 = 3 -> 3*(-2) = -6
        // HF Sx (true): 3
        // Total = 29
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 50, ageAtDx: 35, hfSx: true)
        let result = model.getPoints()
        switch result {
        case .success(let points):
            #expect(points == 29)
        default:
            #expect(Bool(false), "Expected success result")
        }
    }
    
    @Test("getPoints() with heart failure symptoms false correctly adjusts score")
    func pointsCalculationHfSxFalse() async throws {
        // Same as above, but hfSx = false (0 points). Total = 26
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 50, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .success(let points):
            #expect(points == 26)
        default:
            #expect(Bool(false), "Expected success result")
        }
    }

    @Test("getPoints() with nil input returns ParsingError")
    func nilInputReturnsParsingError() async throws {
        let model = HcmAfModel(laDiameter: nil, ageAtEval: 50, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .parsingError)
        default:
            #expect(Bool(false), "Expected failure with parsingError")
        }
    }

    @Test("getPoints() with LA diameter below range returns LaDiameterOutOfRange error")
    func laDiameterBelowRange() async throws {
        let model = HcmAfModel(laDiameter: 23, ageAtEval: 50, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .laDiameterOutOfRange(23))
        default:
            #expect(Bool(false), "Expected failure with LaDiameterOutOfRange")
        }
    }

    @Test("getPoints() with LA diameter above range returns LaDiameterOutOfRange error")
    func laDiameterAboveRange() async throws {
        let model = HcmAfModel(laDiameter: 66, ageAtEval: 50, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .laDiameterOutOfRange(66))
        default:
            #expect(Bool(false), "Expected failure with LaDiameterOutOfRange")
        }
    }

    @Test("getPoints() with Age at Eval below range returns AgeAtEvalOutOfRange error")
    func ageAtEvalBelowRange() async throws {
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 9, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .ageAtEvalOutOfRange(9))
        default:
            #expect(Bool(false), "Expected failure with AgeAtEvalOutOfRange")
        }
    }

    @Test("getPoints() with Age at Eval above range returns AgeAtEvalOutOfRange error")
    func ageAtEvalAboveRange() async throws {
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 80, ageAtDx: 35, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .ageAtEvalOutOfRange(80))
        default:
            #expect(Bool(false), "Expected failure with AgeAtEvalOutOfRange")
        }
    }

    @Test("getPoints() with Age at Dx below range returns AgeAtDxOutOfRange error")
    func ageAtDxBelowRange() async throws {
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 50, ageAtDx: -1, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .ageAtDxOutOfRange(-1))
        default:
            #expect(Bool(false), "Expected failure with AgeAtDxOutOfRange")
        }
    }

    @Test("getPoints() with Age at Dx above range returns AgeAtDxOutOfRange error")
    func ageAtDxAboveRange() async throws {
        let model = HcmAfModel(laDiameter: 40, ageAtEval: 50, ageAtDx: 80, hfSx: false)
        let result = model.getPoints()
        switch result {
        case .failure(let error):
            #expect(error == .ageAtDxOutOfRange(80))
        default:
            #expect(Bool(false), "Expected failure with AgeAtDxOutOfRange")
        }
    }

    // MARK: - getRiskData() Tests

    @Test("getRiskData() for low risk score returns correct data")
    func riskDataForLowScore() async throws {
        let score = 10
        let riskData = HcmAfModel.riskData(for: score)
        #expect(riskData != nil)
        #expect(riskData?.score == 10)
        #expect(riskData?.riskCategory == .low)
        #expect(abs((riskData?.riskAt2YearsPercent ?? -1) - 0.6) < 0.001)
        #expect(abs((riskData?.riskAt5YearsPercent ?? -1) - 1.4) < 0.001)
    }

    @Test("getRiskData() for intermediate risk score returns correct data")
    func riskDataForIntermediateScore() async throws {
        let score = 20
        let riskData = HcmAfModel.riskData(for: score)
        #expect(riskData != nil)
        #expect(riskData?.score == 20)
        #expect(riskData?.riskCategory == .intermediate)
        #expect(abs((riskData?.riskAt2YearsPercent ?? -1) - 3.8) < 0.001)
        #expect(abs((riskData?.riskAt5YearsPercent ?? -1) - 8.9) < 0.001)
    }

    @Test("getRiskData() for high risk score returns correct data")
    func riskDataForHighScore() async throws {
        let score = 30
        let riskData = HcmAfModel.riskData(for: score)
        #expect(riskData != nil)
        #expect(riskData?.score == 30)
        #expect(riskData?.riskCategory == .high)
        #expect(abs((riskData?.riskAt2YearsPercent ?? -1) - 22.0) < 0.001)
        #expect(abs((riskData?.riskAt5YearsPercent ?? -1) - 45.2) < 0.001)
    }

    @Test("getRiskData() for score below valid range returns nil")
    func riskDataBelowRangeReturnsNil() async throws {
        let riskData = HcmAfModel.riskData(for: 7)
        #expect(riskData == nil)
    }

    @Test("getRiskData() for score above valid range returns nil")
    func riskDataAboveRangeReturnsNil() async throws {
        let riskData = HcmAfModel.riskData(for: 32)
        #expect(riskData == nil)
    }
}
