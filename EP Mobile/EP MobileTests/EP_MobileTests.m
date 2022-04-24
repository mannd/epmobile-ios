//
//  EP_MobileTests.m
//  EP MobileTests
//
//  Created by David Mann on 6/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EP_MobileTests.h"
#import "EPSQTcCalculatorViewController.h"
#import "EPSWarfarinDailyDoseCalculator.h"
#import "EPSWarfarinCalculatorViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"
#import "EPSRiskScore.h"
#import "EPSRiskFactor.h"
#import "EPSChadsRiskScore.h"
#import "EPSQTMethods.h"
#import "EPSCMSModel.h"
#import "EPSCMSViewModel.h"
//#import "EP_Mobile-Swift.h"

#define MESSAGE_L @"Actual result was %ld"

@implementation EP_MobileTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testActualWeeklyDose {
    float newDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:.5 fromOldDose:100 isIncrease:NO];
    XCTAssertTrue(newDose == 50.0, @"Actual was %f", newDose);
    newDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:.5 fromOldDose:100 isIncrease:YES];
    XCTAssertTrue(newDose == 150.0, @"Actual was %f", newDose);
    newDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:.5 fromOldDose:50 isIncrease:NO];
    XCTAssertTrue(newDose == 25.0, @"Actual was %f", newDose);
}

- (void)testTryDoses {
    EPSWarfarinDailyDoseCalculator *calculator = [[EPSWarfarinDailyDoseCalculator alloc] initWithTabletDose:7.5 andWeeklyDose:80];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    XCTAssertNoThrow(array = [calculator weeklyDoses], @"It threw!");
    
}

- (void)testIsDoseSane {
    EPSWarfarinCalculatorViewController *vc = [[EPSWarfarinCalculatorViewController alloc] init];
    XCTAssertTrue([vc weeklyDoseIsSane:40 forTabletSize:5]);
    XCTAssertTrue([vc weeklyDoseIsSane:50 forTabletSize:5]);
    XCTAssertTrue([vc weeklyDoseIsSane:30 forTabletSize:5]);
}

- (void)testRound {
    XCTAssertTrue(round(1.2) == 1);
    XCTAssertTrue(round(1.6) == 2);
    XCTAssertTrue(round(1.5) == 2);
}

- (void)testCreatinineConversion {
    EPSDrugDoseCalculatorViewController *vc = [[EPSDrugDoseCalculatorViewController alloc] init];
    XCTAssertEqualWithAccuracy([vc creatinineFromMicroMolUnits:150.0], 1.696, 0.01);
    XCTAssertEqualWithAccuracy([vc creatinineFromMicroMolUnits:87.5], 0.98981, 0.01);

}

- (void)testRiskFactor {
    EPSChadsRiskScore *riskScore = [[EPSChadsRiskScore alloc] init];
    NSArray *risks = [riskScore getArray ];
    NSArray *risksSelected = [riskScore risksSelected:risks];
    NSString *riskString = [EPSRiskScore formatRisks:risksSelected];
    XCTAssertTrue([riskString isEqualToString:@"None"]);
    EPSRiskFactor *risk0 = [risks objectAtIndex:0];
    risk0.isSelected = YES;
    EPSRiskFactor *risk2 = [risks objectAtIndex:2];
    risk2.isSelected = YES;
    risksSelected = [riskScore risksSelected:risks];
    riskString = [EPSRiskScore formatRisks:risksSelected];
    XCTAssertTrue([riskString isEqualToString:@"Congestive heart failure, Age ≥ 75 years"]);
    
}

- (void)testQTMethods {
    long result = [EPSQTMethods qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:kBazett];
    XCTAssertTrue(result == 400, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:kFridericia];
    XCTAssertTrue(result == 400, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:kSagie];
    XCTAssertTrue(result == 400, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:kHodges];
    XCTAssertTrue(result == 400, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:kBazett];
    XCTAssertTrue(result == 411, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:kFridericia];
    XCTAssertTrue(result == 395, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:kSagie];
    XCTAssertTrue(result == 397, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:kHodges];
    XCTAssertTrue(result == 393, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:0 AndIntervalInMsec:0 UsingFormula:kBazett];
    XCTAssertTrue(result == 0, MESSAGE_L, result);
    result = [EPSQTMethods qtcFromQtInMsec:498 AndIntervalInMsec:683 UsingFormula:kBazett];
    XCTAssertTrue(result == 603, MESSAGE_L, result);
    // make sure rounding works the way we want
    XCTAssertTrue(round(0.5) == 1, MESSAGE_L, result);
    XCTAssertTrue(round(0.4) == 0, MESSAGE_L, result);
    XCTAssertTrue(round(0.6) == 1, MESSAGE_L, result);
}

- (void)testCorrectQTForBBB {
    long result = [EPSQTMethods qtCorrectedForLBBBFromQTInMSec:360 andQRSInMsec:144];
    XCTAssertTrue(result == 290, MESSAGE_L, result);
    result = [EPSQTMethods qtCorrectedForLBBBFromQTInMSec:444 andQRSInMsec:197];
    XCTAssertTrue(result == 348, MESSAGE_L, result);
    result = [EPSQTMethods qtCorrectedForLBBBFromQTInMSec:400 andQRSInMsec:0];
    XCTAssertTrue(result == 400, MESSAGE_L, result);
}

- (void)testCorrectJT {
    long result = [EPSQTMethods jtCorrectedFromQTInMsec:360 andIntervalInMsec:550 withQRS:135];
    long qtc = [EPSQTMethods qtcFromQtInMsec:360 AndIntervalInMsec:550 UsingFormula:kBazett];
    XCTAssertTrue(result == qtc - 135, MESSAGE_L, result);
}

- (void)testJT {
    long result = [EPSQTMethods jtFromQTInMsec:398.4 andQRSInMsec:99];
    XCTAssertTrue(result == (NSInteger)(398.4 - 99), MESSAGE_L, result);
}

- (void)testCorrectQTForBBBAndSex {
    long result = [EPSQTMethods qtCorrectedForIVCDAndSexFromQTInMsec:379 AndHR:77 AndQRS:155 IsMale:YES];
    XCTAssertTrue(result == 376, MESSAGE_L, result);
    result = [EPSQTMethods qtCorrectedForIVCDAndSexFromQTInMsec:442 AndHR:55 AndQRS:110 IsMale:NO];
    XCTAssertTrue(result == 421, MESSAGE_L, result);
}

- (void)testPreLbbbQtc {
    long result = [EPSQTMethods prelbbbqtcFromQTInMsec:333 andIntervalInMsec:789 withQRS:166 isMale:YES];
    XCTAssertTrue(result == 304, MESSAGE_L, result);
    result = [EPSQTMethods prelbbbqtcFromQTInMsec:333 andIntervalInMsec:789 withQRS:166 isMale:NO];
    XCTAssertTrue(result == 297, MESSAGE_L, result);
}

- (void)testCMSModel {
    EPSCMSModel *model = [[EPSCMSModel alloc] init];
    struct Result result = [model getResult];
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.indication == IndicationNone);
    XCTAssert(result.details == NoIndications);
    XCTAssert(result.needsSdmEncounter == NO);
    [self absoluteExclusionTests:model];
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.details == NoIndications);
    model.cardiacArrest = YES;
    result = [model getResult];
    // problem now is no ef
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.details == NoEF);
    // Absolute exclusions still override No EF and No Indications so test it again
    [self absoluteExclusionTests:model];
    // try ting something else with no EF
    model.cardiacArrest = NO;
    model.icdAtEri = YES;
    result = [model getResult];
    XCTAssert(result.details == NoEF);
    // re model
    model = [self newModel];
    result = [model getResult];
    XCTAssert(result.details == NoIndications);
    model.susVT = YES;
    result = [model getResult];
    XCTAssert(result.details == NoEF);
    model.ef = EFMoreThan35;
    result = [model getResult];
    XCTAssert(result.details == DetailsNone);
    XCTAssert(result.indication == Secondary);
    XCTAssert(result.approval == Approved);
    XCTAssert(!result.needsSdmEncounter);
    [self absoluteExclusionTests:model];
    model.susVT = NO;
    model.highRiskCondition = YES;
    result = [model getResult];
    XCTAssert(result.details == DetailsNone);
    XCTAssert(result.indication == Primary);
    XCTAssert(result.approval == Approved);
    XCTAssert(result.needsSdmEncounter);
    model.highRiskCondition = NO;
    model.icdAtEri = YES;
    // waiting period exception only occurs when there is a possible waiting period
    model.miWithin40Days = YES;
    result = [model getResult];
    XCTAssert(result.details == WaitingPeriodException);
    XCTAssert(result.indication == Other);
    XCTAssert(result.approval == Approved);
    XCTAssert(!result.needsSdmEncounter);
    model.miWithin40Days = NO;
    result = [model getResult];
    XCTAssert(result.details == DetailsNone);
    model.icdAtEri = NO;
    // MADIT II indication
    model.priorMI = YES;
    result = [model getResult];
    XCTAssert(result.details == NoNyha);
    XCTAssert(result.indication == Primary);
    XCTAssert(result.approval == ApprovalUnclear);
    XCTAssert(!result.needsSdmEncounter);
    model.nyha = NyhaI;
    model.ef = EFLessThan30;
    [self primaryPreventionApproved:model];
    // Class IV excluded form MADIT II
    model.nyha = NyhaIV;
    [self primaryPreventionNotApproved:model];
    // ScdHeft
    model.nyha = NyhaII;
    model.priorMI = NO;
    model.icm = YES;
    model.ef = EFFrom30To35;
    [self primaryPreventionApproved:model];
    model.nyha = NyhaIII;
    [self primaryPreventionApproved:model];
    model.icm = NO;
    model.nicm = YES;
    [self primaryPreventionApproved:model];
    // ting prior MI shouldn't make a difference
    model.priorMI = YES;
    [self primaryPreventionApproved:model];
    // clear model
    model = [self newModel];
    // check forgot ICM in patient with prior MI
    model.ef = EFFrom30To35;
    model.priorMI = YES;
    model.nyha = NyhaII;
    result = [model getResult];
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.details == ForgotIcm);
    model.nyha = NyhaIII;
    result = [model getResult];
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.details == ForgotIcm);
    model.ef = EFMoreThan35;
    [self primaryPreventionNotApproved:model];
    // check forgot MI in pt with ICM
    model = [self newModel];
    model.ef = EFLessThan30;
    model.icm = YES;
    model.nyha = NyhaI;
    result = [model getResult];
    XCTAssert(result.approval == NotApproved);
    XCTAssert(result.details == ForgotMI);
    // check transplant result
    model = [self newModel];
    model.ef = EFLessThan30;
    model.transplantList = YES;
    result = [model getResult];
    XCTAssert(result.approval == ApprovalUnclear);
    XCTAssert(result.indication == Other);
    XCTAssert(result.details == BridgeToTransplant);
    [self absoluteExclusionTests:model];
    // primary prevention overrides transplant
    model.priorMI = YES;
    model.nyha = NyhaI;
    [self primaryPreventionApproved:model];
    // but since primary prevention indication fails here, transplant result overrides
    model.nyha = NyhaIV;
    result = [model getResult];
    XCTAssert(result.details == BridgeToTransplant);
    
}

- (void)primaryPreventionApproved:(EPSCMSModel *)model {
    struct Result result = [model getResult];
    XCTAssert(result.details == DetailsNone);
    XCTAssert(result.indication == Primary);
    XCTAssert(result.approval == Approved);
    XCTAssert(result.needsSdmEncounter);
}

- (void)primaryPreventionNotApproved:(EPSCMSModel *)model {
    struct Result result = [model getResult];
    XCTAssert(result.details == DetailsNone);
    XCTAssert(result.indication == Primary);
    XCTAssert(result.approval == NotApproved);
    XCTAssert(!result.needsSdmEncounter);
}


- (void)absoluteExclusionTests:(EPSCMSModel *) model {
    model.brainDamage = YES;
    XCTAssert([self isAbsoluteExclusion:model]);
    
    // need to exit with no absolute exclusions set
    model.brainDamage = NO;
    XCTAssert(![self isAbsoluteExclusion:model]);
    XCTAssert(![self isAbsoluteExclusion:model]);
    model.cardiogenicShock = YES;
    XCTAssert([self isAbsoluteExclusion:model]);
    model.cardiogenicShock = NO;
    model.nonCardiacDisease = YES;
    XCTAssert([self isAbsoluteExclusion:model]);
    model.uncontrolledSvt = YES;
    XCTAssert([self isAbsoluteExclusion:model]);
    model.nonCardiacDisease = NO;
    XCTAssert([self isAbsoluteExclusion:model]);
    model.uncontrolledSvt = NO;
    XCTAssert(![self isAbsoluteExclusion:model]);
    // no absolute exclusions  at end of this method

}

- (BOOL)isAbsoluteExclusion:(EPSCMSModel *) model {
    struct Result result = [model getResult];
    return result.details == AbsoluteExclusion;
}

- (EPSCMSModel *)newModel {
    return [[EPSCMSModel alloc] init];
}

- (void)testCMSViewModel {
    EPSCMSViewModel *viewModel = [[EPSCMSViewModel alloc] init];
    NSString *message = [viewModel getMessage];
    struct Result result;
    result.indication = Secondary;
    result.approval = NotApproved;
    result.details = DetailsNone;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"Secondary Prevention\nICD implantation does NOT meet CMS guidelines."]);
    result.indication = Primary;
    result.approval = Approved;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"Primary Prevention\nICD implantation appears to meet CMS guidelines."]);
    result.indication = Other;
    result.approval = ApprovalUnclear;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"Other Indication\nNot enough information to determine if ICD is indicated."]);
    result.indication = IndicationNone;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"\nNot enough information to determine if ICD is indicated."]);
    result.approval = Approved;
    result.indication = Other;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"Other Indication\nICD implantation appears to meet CMS guidelines."]);
    result.indication = Primary;
    result.details = AbsoluteExclusion;
    result.approval = NotApproved;
    message = [viewModel getMessageFromResult:result];
    XCTAssert([message isEqualToString:@"Primary Prevention\nICD implantation does NOT meet CMS guidelines.\nThere are one or more absolute exclusions to ICD implantation."]);
    


}

@end
