//
//  EPSWarfarinCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/20/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinCalculatorViewController.h"

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
}
    
@synthesize weeklyDoseField;
@synthesize inrField;

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
    [self toggleTargetRange:nil];
    [self toggleTabletSize:nil];
}

- (void)viewDidUnload
{
    [self setWeeklyDoseField:nil];
    [self setInrField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
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
}

- (IBAction)calculateButtonPressed:(id)sender {
    BOOL hasError = NO;
    NSString *message = @"";
    BOOL showDoses = NO;
    NSString *inrText = [self.inrField text];
    float inr = [inrText floatValue];
    NSString *weeklyDoseText = [self.weeklyDoseField text];
    float weeklyDose = [weeklyDoseText floatValue];
    if (inr == 0 || weeklyDose == 0) {
        hasError = YES;
        message = @"Invalid Entries!";
    }
    else if (inr >= 6.0)
        message = @"Hold warfarin until INR back in therapeutic range.";
    else if ([self inrTherapeutic:inr])
        message = @"INR is therapeutic. No change in warfarin dose.";
    else {
        EPSDoseChange *doseChange = [self percentDoseChange:inr];
        if (doseChange.lowEnd == 0 || doseChange.highEnd == 0)
            message = @"Invalid Entries!";
        else {
            if (doseChange.message != nil)
                message = [doseChange.message stringByAppendingString:@"\n"];
            if (doseChange.direction == INCREASE)
                message = [message stringByAppendingString:@"Increase "];
            else 
                message = [message stringByAppendingString:@"Decrease "];
            message = [message stringByAppendingString:@"weekly dose by "];
            message = [message stringByAppendingFormat:@"%d%% to %d%%.", doseChange.lowEnd, doseChange.highEnd];
            showDoses = [self weeklyDoseIsSane:weeklyDose forTabletSize:tabletSize];
            
        }
    }
    if (hasError) {
        [self displayError:message];
        return;
    }
    [self displayResult:message showDosingTable:showDoses];
}
             
- (BOOL)inrTherapeutic:(float)inr {
    return minINR <= inr && inr <= maxINR;
}

- (BOOL)weeklyDoseIsSane:(float)dose forTabletSize:(float)size {
    // need to make sure not only dose is sane, but max change to dose is
    // sane
    return dose - 0.2 * dose >= 7 * 0.5 * tabletSize
    && dose + 0.2 * dose <= 7 * 1.5 * tabletSize;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Button index = %d", buttonIndex);
    if (buttonIndex == 1)   // Reset
        [self clearButtonPressed:nil];
}

- (void)displayError:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                message:message 
                                                delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alert show];
}

- (void)displayResult:(NSString *)message showDosingTable:(BOOL)show {
    NSString *showButtonTitle = nil;
    if (show)
        showButtonTitle = @"Dosing";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggested Dosing Changes" 
                                            message:message 
                                            delegate:self cancelButtonTitle:@"Don't Reset"
                                            otherButtonTitles:@"Reset", showButtonTitle, nil];
    [alert show];
    
}

- (EPSDoseChange *)percentDoseChange:(float)inr {
    if (minINR == 2.0)
        return [self percentDoseChangeLowRange:inr];
    else 
        return [self percentDoseChangeHighRange:inr];
}

- (EPSDoseChange *)percentDoseChangeLowRange:(float)inr {
    EPSDoseChange *doseChange = [[EPSDoseChange alloc] init];
    doseChange.highEnd = 0;
    doseChange.lowEnd = 0;
    doseChange.message = @"";
    doseChange.direction = INCREASE;
    if (inr < 2.0) {
        doseChange.lowEnd = 5;
        doseChange.highEnd = 20;
    } else if (inr >= 3.0 && inr < 3.6) {
        doseChange.lowEnd = 5;
        doseChange.highEnd = 15;
        doseChange.direction = DECREASE;
    } else if (inr >= 3.6 && inr <= 4) {
        doseChange.lowEnd = 10;
        doseChange.highEnd = 15;
        doseChange.message = @"Withhold no dose or one dose.";
        doseChange.direction = DECREASE;
    } else if (inr > 4) {
        doseChange.lowEnd = 10;
        doseChange.highEnd = 20;
        doseChange.message = @"Withhold no dose or one dose.";
        doseChange.direction = DECREASE;
    }
    return doseChange;

}

- (EPSDoseChange *)percentDoseChangeHighRange:(float)inr {
    EPSDoseChange *doseChange = [[EPSDoseChange alloc] init];
    doseChange.highEnd = 0;
    doseChange.lowEnd = 0;
    doseChange.message = @"";
    doseChange.direction = INCREASE;
    if (inr < 2.0) {
        doseChange.lowEnd = 10;
        doseChange.highEnd = 20;
        doseChange.message = @"Give additional dose.";
    } else if (inr >= 2.0 && inr < 2.5) {
        doseChange.lowEnd = 5;
        doseChange.highEnd = 15;
        doseChange.direction = INCREASE;
    } else if (inr > 3.5 && inr < 4.6) {
        doseChange.lowEnd = 5;
        doseChange.highEnd = 15;
        doseChange.direction = DECREASE;
    } else if (inr >= 4.6 && inr < 5.2) {
        doseChange.lowEnd = 10;
        doseChange.highEnd = 20;
        doseChange.message = @"Withhold no dose or one dose.";
        doseChange.direction = DECREASE;
    } else if (inr > 5.2) {
        doseChange.lowEnd = 10;
        doseChange.highEnd = 20;
        doseChange.message = @"Withhold no dose to two doses.";
        doseChange.direction = DECREASE;
    }
    return doseChange;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.weeklyDoseField.text = nil;
    self.inrField.text = nil;
}



@end
