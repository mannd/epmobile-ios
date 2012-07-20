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
    STAssertTrue(result == 1000, @"Test failed");
    result = [c convertInterval:1000];
    STAssertTrue(result == 60, @"Test failed");
    result = [c convertInterval:733];
    STAssertTrue(result == 82, @"Test failed.  Result was %i", result);
}

- (void)testQTcCalculator {
    EPSQTcCalculatorViewController *c = [[EPSQTcCalculatorViewController alloc] init];
    const int BAZETT = 0;
    const int FRIDERICIA = 1;
    const int SAGIE = 2;
    const int HODGES = 3;
    int result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:BAZETT];
    STAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:FRIDERICIA];   
    STAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:SAGIE];
    STAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:400 AndIntervalInMsec:1000 UsingFormula:HODGES];
    STAssertTrue(result == 400, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:BAZETT];
    STAssertTrue(result == 411, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:FRIDERICIA];
    STAssertTrue(result == 395, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:SAGIE];
    STAssertTrue(result == 397, @"Actual result was %d", result);    
    result = [c qtcFromQtInMsec:365 AndIntervalInMsec:789 UsingFormula:HODGES];
    STAssertTrue(result == 393, @"Actual result was %d", result);
    result = [c qtcFromQtInMsec:0 AndIntervalInMsec:0 UsingFormula:BAZETT];
    STAssertTrue(result == 0, @"Actual result was %d", result);
    
}


@end
