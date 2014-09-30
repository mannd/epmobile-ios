//
//  EPSWeightCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 6/29/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSWeightCalculatorViewController.h"
#import "EPSNotesViewController.h"
#import "EPSLogging.h"

@interface EPSWeightCalculatorViewController ()

@end

@implementation EPSWeightCalculatorViewController {
    BOOL weightIsPounds;
    BOOL heightIsInches;
    double calculatedIbw;
    double calculatedAbw;
    NSString *roundedIbw;
    NSString *roundedAbw;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    weightIsPounds = YES;
    heightIsInches = YES;
    calculatedIbw = calculatedAbw = 0.0;
    roundedAbw = @"";
    roundedIbw = @"";
    calculatedIbw = 0.0;
    calculatedAbw = 0.0;
    // defaults here
    [self refreshDefaults];
    if ([self.defaultWeightUnit isEqualToString:@"lb"]) {
        [self setWeightPlaceholder:0];
        [self.weightUnitsSegmentedControl setSelectedSegmentIndex:0];
    }
    else if ([self.defaultWeightUnit isEqualToString:@"kg"]) {
        [self setWeightPlaceholder:1];
        [self.weightUnitsSegmentedControl setSelectedSegmentIndex:1];
    }
    if ([self.defaultHeightUnit isEqualToString:@"in"]) {
        [self setHeightPlaceholder:0];
        [self.heightUnitsSegmentedControl setSelectedSegmentIndex:0];
    }
    else if ([self.defaultHeightUnit isEqualToString:@"cm"]) {
        [self setHeightPlaceholder:1];
        [self.heightUnitsSegmentedControl setSelectedSegmentIndex:1];
    }


}

- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultWeightUnit = [defaults objectForKey:@"defaultweightunit"];
    self.defaultHeightUnit = [defaults objectForKey:@"defaultheightunit"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSexSegmentedControl:nil];
    [self setWeightUnitsSegmentedControl:nil];
    [self setHeightUnitsSegmentedControl:nil];
    [self setWeightTextField:nil];
    [self setHeightTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
}

- (IBAction)calculate:(id)sender {
    NSString *weightText = self.weightTextField.text;
    double weight = [weightText doubleValue];
    NSString *heightText = self.heightTextField.text;
    double height = [heightText doubleValue];
    if (weight <= 0.0 || height <= 0.0) {
        self.resultLabel.text = @"INVALID ENTRY";
        return;
    }
    double weightInPounds = 0;
    if (weightIsPounds) {
        EPSLog(@"Weight is in pounds (%f lb)", weight);
        weightInPounds = weight;
        weight = [self lbsToKgs:weight];
        EPSLog(@"Converted weight in kgs is %f", weight);
    }
    if (! heightIsInches) {
        height = [self cmsToIns:height];
    }
    BOOL isMale = ([self.sexSegmentedControl selectedSegmentIndex] == 0);
    calculatedIbw = [self idealBodyWeightForHeight:height forIsMale:isMale];
    calculatedAbw = [self adjustedBodyWeight:calculatedIbw forActualWeight:weight];
    if (weightIsPounds) {
        calculatedIbw = [self kgsToLbs:calculatedIbw];
        calculatedAbw = [self kgsToLbs:calculatedAbw];
        // change actual weight back to pounds for determining overweight and underweight
        weight = weightInPounds;
    }
    NSString *formattedIbw = [NSString stringWithFormat:@"%.1f", calculatedIbw];
    NSString *formattedAbw = [NSString stringWithFormat:@"%.1f", calculatedAbw];
    NSString *formattedWeight = [NSString stringWithFormat:@"%.1f", weight];
    // these are the string pasted to the clipboard
    roundedIbw = formattedIbw;
    roundedAbw = formattedAbw;

    if (weightIsPounds) {
        formattedIbw = [formattedIbw stringByAppendingString:@" lbs"];
        formattedAbw = [formattedAbw stringByAppendingString:@" lbs"];
        formattedWeight = [formattedWeight stringByAppendingString:@" lbs"];
    }
    else {
        formattedIbw = [formattedIbw stringByAppendingString:@" kgs"];
        formattedAbw = [formattedAbw stringByAppendingString:@" kgs"];
        formattedWeight = [formattedWeight stringByAppendingString:@" kgs"];

    }
    
    NSString *result = @"";
    result = [result stringByAppendingString:[NSString stringWithFormat:@"Ideal Body Weight = %@\nAdjusted Body Weight = %@", formattedIbw, formattedAbw]];
    if ([self isUnderHeight:height])
        result = [result stringByAppendingString:@"\nThese measurements might not be useful when height < 60 inches."];
    else if ([self isOverweight:calculatedIbw forActualWeight:weight])
        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Adjusted Body Weight (%@)", formattedAbw]];
    else if ([self isUnderWeight:weight forIbw:calculatedIbw])
        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Actual Body Weight (%@)", formattedWeight]];
    else // normal weight
        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Ideal Body Weight (%@)", formattedIbw]];
    self.resultLabel.text = result;
}

- (double)lbsToKgs:(double)weight {
    double CONVERSION_FACTOR = 0.45359237;
    return weight * CONVERSION_FACTOR;
}

- (double)kgsToLbs:(double)weight {
    double CONVERSION_FACTOR = 2.20462262;
    return weight * CONVERSION_FACTOR;
}

- (double)cmsToIns:(double)distance {
    double CONVERSION_FACTOR = 0.39370;
    return distance * CONVERSION_FACTOR;
}


- (double)idealBodyWeightForHeight:(double)height forIsMale:(BOOL)isMale {
	double weight = height > 60.0 ? (height - 60.0) * 2.3 : 0.0;
    if (isMale)
        weight += 50.0;
    else
        weight += 45.5;
    return weight;
}

- (double)adjustedBodyWeight:(double)ibw forActualWeight:(double)actualWeight {
    // for now, literature seems to support 0.4 as best correction factor
    double abw = ibw + 0.4 * (actualWeight - ibw);
    abw = actualWeight > ibw ? abw : actualWeight;
    return abw;
}

- (BOOL)isOverweight:(double)ibw forActualWeight:(double)actualWeight {
    return actualWeight > ibw + 0.3 * ibw;
}

- (BOOL)isUnderHeight:(double)height {
    return height <= 60.0;
}

- (BOOL)isUnderWeight:(double)weight forIbw:(double)ibw {
    return weight < ibw;
}

- (IBAction)clear:(id)sender {
    self.heightTextField.text = nil;
    self.weightTextField.text = nil;
    self.resultLabel.text = nil;
}

- (IBAction)copyIbw:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = roundedIbw;
}

- (IBAction)copyAbw:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = roundedAbw;
}

- (IBAction)toggleSex:(id)sender {
    self.resultLabel.text = nil;
}

- (IBAction)toggleWeightUnits:(id)sender {
    self.resultLabel.text = nil;
    [self setWeightPlaceholder:[sender selectedSegmentIndex]];
}

- (void)setWeightPlaceholder:(NSInteger)index {
    NSString *placeholder = @"Wt (";
    if ((weightIsPounds = index == 0))
        self.weightTextField.placeholder = [placeholder stringByAppendingString:@"lb)"];
    else
        self.weightTextField.placeholder = [placeholder stringByAppendingString:@"kg)"];
}

- (IBAction)toggleHeightUnits:(id)sender {
    self.resultLabel.text = nil;
    [self setHeightPlaceholder:[sender selectedSegmentIndex]];
}

- (void)setHeightPlaceholder:(NSInteger)index {
    NSString *placeholder = @"Ht (";
    if ((heightIsInches = index == 0))
        self.heightTextField.placeholder = [placeholder stringByAppendingString:@"in)"];
    else
        self.heightTextField.placeholder = [placeholder stringByAppendingString:@"cm)"];
}


- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.weightTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = @"WeightCalculatorNotes";
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"WeightCalculatorNotesSegue" sender:nil];
}


@end
