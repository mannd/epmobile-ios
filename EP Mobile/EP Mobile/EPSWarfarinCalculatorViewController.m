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
#import "EPSLogging.h"

#define DEFAULT_TABLET_INDEX 5  // 5 mg tablet at index 5


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
    float minINR;
    float maxINR;
    float weeklyDose;
}
    
@synthesize weeklyDoseField;
@synthesize inrField;
@synthesize resultLabel;
@synthesize doseChange;
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
    
    minINR = 2.0;
    maxINR = 3.0;
    NSArray *array = [[NSArray alloc] initWithObjects:@"1 mg", @"2 mg", @"2.5 mg", @"3 mg", @"4 mg", @"5 mg", @"6 mg", @"7.5 mg", @"10 mg", nil];
    self.tabletSizeData = array;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    [self refreshDefaults];
    NSUInteger index = [self.tabletSizeData indexOfObject:self.defaultWarfarinTabletSize];
    if (index == NSNotFound)
        index = DEFAULT_TABLET_INDEX;
    [self.tabletSizePickerView selectRow:index inComponent:0 animated:NO];
    [self.tabletSizePickerView setShowsSelectionIndicator:YES];
    if ([self.defaultINR isEqualToString:@"2"]) {
        [targetSegmentedControl setSelectedSegmentIndex:0];
        minINR = 2.0;
        maxINR = 3.0;
    }
    else if ([self.defaultINR isEqualToString:@"2.5"]) {
        [targetSegmentedControl setSelectedSegmentIndex:1];
        minINR = 2.5;
        maxINR = 3.5;
    }

    
}


- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultWarfarinTabletSize = [defaults objectForKey:@"defaultwarfarintablet"];
    self.defaultINR = [defaults objectForKey:@"defaultinrtarget"];
    EPSLog(@"DefaultWafarinTabletSize = %@", self.defaultWarfarinTabletSize);
    EPSLog(@"DefaultINR = %@", self.defaultINR);

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

- (double)getTabletSize {
    NSInteger row = [tabletSizePickerView selectedRowInComponent:0];
    NSString *tabletSizeString = [tabletSizeData objectAtIndex:row];
    double tabSize = [tabletSizeString doubleValue];
    EPSLog(@"Picker tablet size = %f", tabSize);
    return tabSize;
    
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
            message = [message stringByAppendingFormat:@"%ld%% (%1.1f mg/wk) to %ld%% (%1.1f mg/wk).", (long)doseChange.lowEnd, lowEndDose, (long)doseChange.highEnd, highEndDose];
            showDoses = [self weeklyDoseIsSane:weeklyDose forTabletSize:[self getTabletSize]];
            
        }
    }
    self.resultLabel.text = message;
    if (showDoses) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Show Suggested Daily Doses" otherButtonTitles: nil];
//        [actionSheet showInView:self.view];
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {}];
        UIAlertAction *dailyDoseAction = [UIAlertAction actionWithTitle:@"Show Suggested Daily Doses" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"DosingSegue" sender:nil];
        }];
        
        [actionSheet addAction:dailyDoseAction];
        [actionSheet addAction:defaultAction];
        
        UIPopoverPresentationController *popPresenter = [actionSheet
                                                         popoverPresentationController];
        popPresenter.sourceView = self.calculateButton;
        popPresenter.sourceRect = self.calculateButton.bounds;
        [self presentViewController:actionSheet animated:YES completion:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"WarfarinNotesSegue"]) {
        EPSLog(@"Warfarin notes");
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"WarfarinNotes";
    }
    else if ([segueIdentifier isEqualToString:@"DosingSegue"]) {
        EPSWarfarinDosingTableViewController *dc = (EPSWarfarinDosingTableViewController *)[segue destinationViewController];
        dc.tabletSize = [self getTabletSize];
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
