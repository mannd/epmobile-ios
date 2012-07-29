//
//  EPSDosingTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinDosingTableViewController.h"
#import "EPSWarfarinDailyDoseCalculator.h"

#define NUM_DAYS 7
#define SUN 0
#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6

@interface EPSWarfarinDosingTableViewController ()

@end

@implementation EPSWarfarinDosingTableViewController
@synthesize tueDose1;
@synthesize tueDose2;
@synthesize wedDose1;
@synthesize wedDose2;
@synthesize thuDose1;
@synthesize thuDose2;
@synthesize friDose1;
@synthesize friDose2;
@synthesize satDose1;
@synthesize satDose2;
@synthesize titleBar;
@synthesize totalWeeklyLowDose;
@synthesize totalWeeklyHighDose;
@synthesize titleLabel;
@synthesize lowChangeLabel;
@synthesize highChangeLabel;
@synthesize sunDose1;
@synthesize sunDose2;
@synthesize monDose1;
@synthesize monDose2;
@synthesize tabletSize;
@synthesize lowEnd;
@synthesize highEnd;
@synthesize increase;
@synthesize weeklyDose;

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
    NSString *title = [[NSString alloc] initWithFormat:@"Warfarin Dosing (%g mg tab)", self.tabletSize];
    self.titleBar.title = title;
    self.lowChangeLabel.text = [[NSString alloc] initWithFormat:@"%d%% %@", self.lowEnd,
    self.increase ? @"Increase" : @"Decrease"];
    self.highChangeLabel.text = [[NSString alloc] initWithFormat:@"%d%% %@", self.highEnd, self.increase ? @"Increase" : @"Decrease"];
    
    float newLowEndWeeklyDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(self.lowEnd / 100.0) fromOldDose:self.weeklyDose isIncrease:self.increase];
    float newHighEndWeeklyDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(self.highEnd / 100.0) fromOldDose:self.weeklyDose isIncrease:self.increase];
    EPSWarfarinDailyDoseCalculator *calculator = [[EPSWarfarinDailyDoseCalculator alloc] initWithTabletDose:tabletSize andWeeklyDose:newLowEndWeeklyDose];
    NSMutableArray *array = [calculator weeklyDoses];
    sunDose1.text = [self formatDose:[[array objectAtIndex:SUN] floatValue]];
    monDose1.text = [self formatDose:[[array objectAtIndex:MON] floatValue]];
    tueDose1.text = [self formatDose:[[array objectAtIndex:TUE] floatValue]];
    wedDose1.text = [self formatDose:[[array objectAtIndex:WED] floatValue]];
    thuDose1.text = [self formatDose:[[array objectAtIndex:THU] floatValue]];
    friDose1.text = [self formatDose:[[array objectAtIndex:FRI] floatValue]];
    satDose1.text = [self formatDose:[[array objectAtIndex:SAT] floatValue]];
    float total = [self totalDose:array tabletDose:tabletSize];
    NSString *totalLowDose = [[NSString alloc] initWithFormat:@"%1.1f mg/wk", total];
    self.totalWeeklyLowDose.text = totalLowDose;
    [calculator setWeeklyDose:newHighEndWeeklyDose];
    array = [calculator weeklyDoses];
    sunDose2.text = [self formatDose:[[array objectAtIndex:SUN] floatValue]];
    monDose2.text = [self formatDose:[[array objectAtIndex:MON] floatValue]];
    tueDose2.text = [self formatDose:[[array objectAtIndex:TUE] floatValue]];
    wedDose2.text = [self formatDose:[[array objectAtIndex:WED] floatValue]];
    thuDose2.text = [self formatDose:[[array objectAtIndex:THU] floatValue]];
    friDose2.text = [self formatDose:[[array objectAtIndex:FRI] floatValue]];
    satDose2.text = [self formatDose:[[array objectAtIndex:SAT] floatValue]];
    total = [self totalDose:array tabletDose:tabletSize];
    NSString *totalHighDose = [[NSString alloc] initWithFormat:@"%1.1f mg/wk", total];
    self.totalWeeklyHighDose.text = totalHighDose;
}

- (float)totalDose:(NSMutableArray *)doses tabletDose:(float)tabletDose {
    float total = 0.0;
    for (int i = 0; i < NUM_DAYS; ++i)
        total += [[doses objectAtIndex:i] floatValue] * tabletDose;
    return total;
}

- (NSString *)formatDose:(float)dose {
    return [[NSString alloc] initWithFormat:@"%1.1f tab", dose];
}

- (void)viewDidUnload
{
    [self setSunDose1:nil];
    [self setSunDose2:nil];
    [self setMonDose1:nil];
    [self setMonDose2:nil];
    [self setTueDose1:nil];
    [self setTueDose2:nil];
    [self setWedDose1:nil];
    [self setWedDose2:nil];
    [self setThuDose1:nil];
    [self setThuDose2:nil];
    [self setFriDose1:nil];
    [self setFriDose2:nil];
    [self setSatDose1:nil];
    [self setSatDose2:nil];
    [self setTitleLabel:nil];
    [self setTitleBar:nil];
    [self setLowChangeLabel:nil];
    [self setHighChangeLabel:nil];
    [self setTotalWeeklyLowDose:nil];
    [self setTotalWeeklyHighDose:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
