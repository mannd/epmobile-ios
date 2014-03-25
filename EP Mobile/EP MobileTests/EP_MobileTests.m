//
//  EP_MobileTests.m
//  EP MobileTests
//
//  Created by David Mann on 6/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EP_MobileTests.h"
#import "EPSCycleLengthCalculatorViewController.h"
#import "EPSQTcCalculatorViewController.h"
#import "EPSWarfarinDailyDoseCalculator.h"
#import "EPSWarfarinCalculatorViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"

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

- (void)testCycleLengthCalculator {
    EPSCycleLengthCalculatorViewController *c = [[EPSCycleLengthCalculatorViewController alloc] init];
    int result = [c convertInterval:60];
    XCTAssertTrue(result == 1000, @"Test failed");
    result = [c convertInterval:1000];
    XCTAssertTrue(result == 60, @"Test failed");
    result = [c convertInterval:733];
    XCTAssertTrue(result == 82, @"Test failed.  Result was %i", result);
}

- (void)testQTcCalculator {
    EPSQTcCalculatorViewController *c = [[EPSQTcCalculatorViewController alloc] init];
    const int BAZETT = 0;
    const int FRIDERICIA = 1;
    const int SAGIE = 2;
    const int HODGES = 3;
    int result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:BAZETT];
    XCTAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:FRIDERICIA];   
    XCTAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:SAGIE];
    XCTAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:HODGES];
    XCTAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:BAZETT];
    XCTAssertTrue(result == 411, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:FRIDERICIA];
    XCTAssertTrue(result == 395, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:SAGIE];
    XCTAssertTrue(result == 397, @"Actual result was %d", result);    
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:HODGES];
    XCTAssertTrue(result == 393, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:0 AndIntervalInMsec:0 UsingFormula:BAZETT];
    XCTAssertTrue(result == 0, @"Actual result was %d", result);
    
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


@end
