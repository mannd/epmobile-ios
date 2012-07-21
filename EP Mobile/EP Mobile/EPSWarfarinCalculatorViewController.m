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
    tabletSize = 5.0;   // default tablet size
    minINR = 2.0;       // default lower end of dosing range
    maxINR = 3.0;
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
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
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

- (IBAction)calculateButtonPressed:(id)sender {
    NSString *message = @"";
    BOOL showDoses = NO;
    NSString *inrText = [self.inrField text];
    float inr = [inrText floatValue];
    NSString *weeklyDoseText = [self.weeklyDoseField text];
    float weeklyDose = [weeklyDoseText floatValue];
    if (inr >= 6.0)
        message = @"Hold warfarin until INR back in therapeutic range.";
    else if ([self inrTherapeutic:inr])
        message = @"INR is therapeutic. No change in warfarin dose.";
    else 
        ;
    [self displayResult:message];
    
    
}
             
- (BOOL)inrTherapeutic:(float)inr {
    return minINR <= inr && inr <= maxINR;
}

- (void)displayResult:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggested Warfarin Dosing" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)clearButtonPressed:(id)sender {
    self.weeklyDoseField.text = nil;
    self.inrField.text = nil;
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
@end
