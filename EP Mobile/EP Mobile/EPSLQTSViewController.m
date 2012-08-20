//
//  EPSLQTSViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLQTSViewController.h"
#import "EPSRiskFactor.h"

@interface EPSLQTSViewController ()

@end

@implementation EPSLQTSViewController
@synthesize qtcSegmentedControl;
@synthesize sexSegmentedControl;
@synthesize riskTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [qtcSegmentedControl setTitle:@"< 450" forSegmentAtIndex:0];
    [qtcSegmentedControl setTitle:@"450" forSegmentAtIndex:1];
    [qtcSegmentedControl setTitle:@"≥ 460" forSegmentAtIndex:2];
    [qtcSegmentedControl setTitle:@"≥ 480" forSegmentAtIndex:3];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"< 120 msec" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sudden cardiac arrest" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Polymorphic VT or VF" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained syncope" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Atrial fibrillation" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"1\u00B0 or 2\u00B0 relative with SQTS" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"1\u00B0 or 2\u00B0 relative with SCD" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sudden Infant Death Syndrome" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Genotype positive" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Mutation in culprit gene" withValue:1]];
    self.risks = array;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;


}

- (void)viewDidUnload
{
    [self setQtcSegmentedControl:nil];
    [self setSexSegmentedControl:nil];
    [self setRiskTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
