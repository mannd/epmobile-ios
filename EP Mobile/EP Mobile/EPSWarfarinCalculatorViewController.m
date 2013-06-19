//
//  EPSWarfarinCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/20/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinCalculatorViewController.h"
#import "EPSWarfarinDosingTableViewController.h"
#import "EPSWarfarinDailyDoseCalculator.h"
#import "EPSNotesViewController.h"


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
@synthesize tabletSizeSegmentedControl;
@synthesize targetSegmentedControl;
@synthesize tabletSizePickerView;
@synthesize tabletSizeData;

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
    NSArray *array = [[NSArray alloc] initWithObjects:@"1 mg", @"2 mg", @"2.5 mg", @"3 mg", @"4 mg", @"5 mg", @"6 mg", @"7.5 mg", @"10 mg", nil];
    self.tabletSizeData = array;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    [self refreshDefaults];
    if ([self.defaultWarfarinTabletSize isEqualToString:@"2"]) {
        [tabletSizeSegmentedControl setSelectedSegmentIndex:0];
        tabletSize = 2.0;
    }
    else if ([self.defaultWarfarinTabletSize isEqualToString:@"2.5"]) {
        [tabletSizeSegmentedControl setSelectedSegmentIndex:1];
        tabletSize = 2.5;
    }
    else if ([self.defaultWarfarinTabletSize isEqualToString:@"5"]) {
        [tabletSizeSegmentedControl setSelectedSegmentIndex:2];
        tabletSize = 5.0;
    }
    else if ([self.defaultWarfarinTabletSize isEqualToString:@"7.5"]) {
        [tabletSizeSegmentedControl setSelectedSegmentIndex:3];
        tabletSize = 7.5;
    }
    if ([self.defaultINR isEqualToString:@"2"]) {
        [targetSegmentedControl setSelectedSegmentIndex:0];
        minINR = 2.0;
        maxINR = 3.0;
    }
    else if ([self.defaultINR isEqualToString:@"2.5"]){
        [targetSegmentedControl setSelectedSegmentIndex:1];
        minINR = 2.5;
        maxINR = 3.5;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUInteger index = [self.tabletSizeData indexOfObject:self.defaultWarfarinTabletSize];
    if (index == NSNotFound)
        index = 0;
    [self.tabletSizePickerView selectRow:index inComponent:0 animated:YES];
}

- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultWarfarinTabletSize = [defaults objectForKey:@"defaultwarfarintablet"];
    self.defaultINR = [defaults objectForKey:@"defaultinrtarget"];
    NSLog(@"DefaultWafarinTabletSize = %@", self.defaultWarfarinTabletSize);
    NSLog(@"DefaultINR = %@", self.defaultINR);

}

- (void)viewDidUnload
{
    [self setWeeklyDoseField:nil];
    [self setInrField:nil];
    [self setResultLabel:nil];
    [self setDoseChange:nil];
    [self setTabletSizeSegmentedControl:nil];
    [self setTargetSegmentedControl:nil];
    [self setTabletSizePickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"WarfarinNotesSegue" sender:nil];
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
    NSString *message = @"";
    BOOL showDoses = NO;
    NSString *inrText = [self.inrField text];
    float inr = [inrText floatValue];
    NSString *weeklyDoseText = [self.weeklyDoseField text];
    weeklyDose = [weeklyDoseText floatValue];
    if (inr <= 0 || weeklyDose <= 0) {
        message = @"INVALID ENTRY";
    }
    else if (inr >= 6.0)
        message = @"Hold warfarin until INR back in therapeutic range.";
    else if ([self inrTherapeutic:inr])
        message = @"INR is therapeutic. No change in warfarin dose.";
    else {
        doseChange = [self percentDoseChange:inr];
        if (doseChange.lowEnd <= 0 || doseChange.highEnd <= 0)
            message = @"INVALID ENTRY";
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
    //return dose - 0.2 * dose >= 7 * 0.5 * tabletSize && dose + 0.2 * dose <= 7 * 2.0 * tabletSize;
    // dose calculator algorithm should handle from about 3 half tabs a week to 2 tabs daily
    return (dose > (4 * 0.5 * size)) && (dose < (2 * size * 7));
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSLog(@"Flip view");
        [self performSegueWithIdentifier:@"DosingSegue" sender:nil];
    }
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"WarfarinNotesSegue"]) {
        NSLog(@"Warfarin notes");
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"WarfarinNotes";
    }
    else if ([segueIdentifier isEqualToString:@"DosingSegue"]) {
        EPSWarfarinDosingTableViewController *dc = (EPSWarfarinDosingTableViewController *)[segue destinationViewController];
        dc.tabletSize = tabletSize;
        dc.lowEnd = doseChange.lowEnd;
        dc.highEnd = doseChange.highEnd;
        dc.increase = (doseChange.direction == INCREASE);
        dc.weeklyDose = weeklyDose;
    }
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
        dc.message = @"Consider holding one dose.";
        dc.direction = DECREASE;
    } else if (inr > 5.2) {
        dc.lowEnd = 10;
        dc.highEnd = 20;
        dc.message = @"Consider holding up to two doses.";
        dc.direction = DECREASE;
    }
    return dc;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.weeklyDoseField.text = nil;
    self.inrField.text = nil;
    self.resultLabel.text = nil;
}


#pragma mark - Formula Picker Data Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [tabletSizeData count];
}


# pragma mark - Formula Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [tabletSizeData objectAtIndex:row];
}




@end
