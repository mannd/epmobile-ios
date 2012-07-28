//
//  EPSWarfarinCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/20/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinCalculatorViewController.h"
#import "EPSDosingTableViewController.h"
#import "EPSWarfarinDailyDoseCalculator.h"


@interface EPSWarfarinCalculatorViewController ()

@end

@implementation EPSDoseChange
@synthesize lowEnd;
@synthesize highEnd;
@synthesize message;
@synthesize direction;
@end

@implementation EPSWarfarinCalculatorViewController
{
    float tabletSize;
    float minINR;
    float maxINR;
    float weeklyDose;
}
    
@synthesize weeklyDoseField;
@synthesize inrField;
@synthesize resultLabel;
@synthesize doseChange;

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
    // set defaults
    tabletSize = 5.0;
    minINR = 2.0;
    maxINR = 3.0;
}

- (void)viewDidUnload
{
    [self setWeeklyDoseField:nil];
    [self setInrField:nil];
    [self setResultLabel:nil];
    [self setDoseChange:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.weeklyDoseField resignFirstResponder];
    [self.inrField resignFirstResponder];
}


- (IBAction)toggleTargetRange:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            minINR = 2.0;
            maxINR = 3.0;
            break;
        case 1:
            minINR = 2.5;
            maxINR = 3.5;
            break;
        default:
            break;
    }
}

- (IBAction)toggleTabletSize:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            tabletSize = 2.0;
            break;
        case 1:
            tabletSize = 2.5;
            break;
        case 2:
            tabletSize = 5.0;
            break;
        case 3:
            tabletSize = 7.5;
            break;
        default:
            tabletSize = 5.0;
            break;
    }
    NSLog(@"Tablet size = %f", tabletSize);
}

- (IBAction)calculateButtonPressed:(id)sender {
    BOOL hasError = NO;
    NSString *message = @"";
    BOOL showDoses = NO;
    NSString *inrText = [self.inrField text];
    float inr = [inrText floatValue];
    NSString *weeklyDoseText = [self.weeklyDoseField text];
    weeklyDose = [weeklyDoseText floatValue];
    if (inr == 0 || weeklyDose == 0) {
        hasError = YES;
        message = @"Invalid Entries!";
    }
    else if (inr >= 6.0)
        message = @"Hold warfarin until INR back in therapeutic range.";
    else if ([self inrTherapeutic:inr])
        message = @"INR is therapeutic. No change in warfarin dose.";
    else {
        doseChange = [self percentDoseChange:inr];
        if (doseChange.lowEnd == 0 || doseChange.highEnd == 0)
            message = @"Invalid Entries!";
        else {
            if (doseChange.message != nil)
                message = [doseChange.message stringByAppendingString:@"\n"];
            BOOL increaseDose = (doseChange.direction == INCREASE);
            if (increaseDose)
                message = [message stringByAppendingString:@"Increase "];
            else 
                message = [message stringByAppendingString:@"Decrease "];
            float lowEndDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(doseChange.lowEnd / 100.0) fromOldDose:weeklyDose isIncrease:(increaseDose)];
            float highEndDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(doseChange.highEnd / 100.0) fromOldDose:weeklyDose isIncrease:(increaseDose)];
            message = [message stringByAppendingString:@"weekly dose by "];
            message = [message stringByAppendingFormat:@"%d%% (%1.1f mg/wk) to %d%% (%1.1f mg/wk).", doseChange.lowEnd, lowEndDose, doseChange.highEnd, highEndDose];
            showDoses = [self weeklyDoseIsSane:weeklyDose forTabletSize:tabletSize];
            
        }
    }
    self.resultLabel.text = message;
    if (showDoses) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Show Suggested Daily Doses" otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
}
             
- (BOOL)inrTherapeutic:(float)inr {
    return minINR <= inr && inr <= maxINR;
}

- (BOOL)weeklyDoseIsSane:(float)dose forTabletSize:(float)size {
    // need to make sure not only dose is sane, but max change to dose is
    // sane
    return dose - 0.2 * dose >= 7 * 0.5 * tabletSize && dose + 0.2 * dose <= 7 * 1.5 * tabletSize;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSLog(@"Flip view");
        [self performSegueWithIdentifier:@"DosingSegue" sender:nil];
    }
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSDosingTableViewController *dc = (EPSDosingTableViewController *)[segue destinationViewController]; 
    dc.tabletSize = tabletSize;
    dc.lowEnd = doseChange.lowEnd;
    dc.highEnd = doseChange.highEnd;
    dc.increase = (doseChange.direction == INCREASE);
    dc.weeklyDose = weeklyDose;
}



- (EPSDoseChange *)percentDoseChange:(float)inr {
    if (minINR == 2.0)
        return [self percentDoseChangeLowRange:inr];
    else 
        return [self percentDoseChangeHighRange:inr];
}

- (EPSDoseChange *)percentDoseChangeLowRange:(float)inr {
    EPSDoseChange *dc = [[EPSDoseChange alloc] init];
    dc.highEnd = 0;
    dc.lowEnd = 0;
    dc.message = @"";
    if (inr >= 3.6)
        dc.message = @"Consider holding one dose.";
    dc.direction = INCREASE;
    if (inr < 2.0) {
        dc.lowEnd = 5;
        dc.highEnd = 20;
    } else if (inr >= 3.0 && inr < 3.6) {
        dc.lowEnd = 5;
        dc.highEnd = 15;
        dc.direction = DECREASE;
    } else if (inr >= 3.6 && inr <= 4) {
        dc.lowEnd = 10;
        dc.highEnd = 15;
        dc.direction = DECREASE;
    } else if (inr > 4) {
        dc.lowEnd = 10;
        dc.highEnd = 20;
        dc.direction = DECREASE;
    }
    return dc;

}

- (EPSDoseChange *)percentDoseChangeHighRange:(float)inr {
    EPSDoseChange *dc = [[EPSDoseChange alloc] init];
    dc.highEnd = 0;
    dc.lowEnd = 0;
    dc.message = @"";
    if (inr >= 4.6)
        dc.message = @"Consider holding one dose.";
    dc.direction = INCREASE;
    if (inr < 2.0) {
        dc.lowEnd = 10;
        dc.highEnd = 20;
        dc.message = @"Give additional dose.";
    } else if (inr >= 2.0 && inr < 2.5) {
        dc.lowEnd = 5;
        dc.highEnd = 15;
        dc.direction = INCREASE;
    } else if (inr > 3.5 && inr < 4.6) {
        dc.lowEnd = 5;
        dc.highEnd = 15;
        dc.direction = DECREASE;
    } else if (inr >= 4.6 && inr < 5.2) {
        dc.lowEnd = 10;
        dc.highEnd = 20;
        dc.direction = DECREASE;
    } else if (inr > 5.2) {
        dc.lowEnd = 10;
        dc.highEnd = 20;
        dc.direction = DECREASE;
    }
    return dc;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.weeklyDoseField.text = nil;
    self.inrField.text = nil;
    self.resultLabel.text = nil;
}



@end
