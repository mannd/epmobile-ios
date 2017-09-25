//
//  EPSDrugDoseCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSDrugDoseCalculatorViewController.h"
#import "EPSNotesViewController.h"
#import "EPSLogging.h"
#import "EPSSharedMethods.h"

#define DABIGATRAN @"Dabigatran"
#define DOFETILIDE @"Dofetilide"
#define RIVAROXABAN @"Rivaroxaban"
#define SOTALOL @"Sotalol"
#define APIXABAN @"Apixaban"
#define EDOXABAN @"Edoxaban"
#define CREATININE_CLEARNCE_ONLY @"Creatinine Clearance"

#define DO_NOT_USE @"DO NOT USE! "
#define APIXABAN_2_5_CAUTION @"Avoid coadministration with strong dual inhibitors of CYP3A4 and P-gp "
#define APIXABAN_5_CAUTION @"Use 2.5 mg twice daily when administered with strong dual inhibitors of CYP3A4 and P-gp "
#define APIXABAN_ESRD_CAUTION @"\nUse with caution in patients with ESRD on dialysis"
#define INHIBITORS @"(e.g. ketoconazole, itraconazole, ritonavir, clarithromycin)."
#define AFB_DOSING_ONLY_WARNING @"\nDosing only for non-valvular AF (not DVT/PE or other indications)"



@interface EPSDrugDoseCalculatorViewController ()

@end

@implementation EPSDrugDoseCalculatorViewController
{
    BOOL weightIsPounds;
    BOOL unitsAreMgPerDl;
    UITextField *activeField;
    CGRect originalBounds;
}
@synthesize sexSegmentedControl;
@synthesize ageField;
@synthesize weightField;
@synthesize weightUnitsSegmentedControl;
@synthesize creatinineUnitsSegmentedControl;
@synthesize creatinineField;
@synthesize resultLabel;
@synthesize drug;



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
    self.navigationItem.title = drug;
    weightIsPounds = YES;
    unitsAreMgPerDl = YES;
    [self refreshDefaults];
    if ([self.defaultWeightUnit isEqualToString:@"lb"]) {
        [self setWeightPlaceholder:0];
        [weightUnitsSegmentedControl setSelectedSegmentIndex:0];
    }
    else if ([self.defaultWeightUnit isEqualToString:@"kg"]) {
        [self setWeightPlaceholder:1];
        [weightUnitsSegmentedControl setSelectedSegmentIndex:1];
    }
    if ([self.defaultCreatinineUnit isEqualToString:@"mg"]) {
        [self setCrUnitsPlaceholder:0];
        [creatinineUnitsSegmentedControl setSelectedSegmentIndex:0];
    }
    else if ([self.defaultCreatinineUnit isEqualToString:@"micromol"]) {
        [self setCrUnitsPlaceholder:1];
        [creatinineUnitsSegmentedControl setSelectedSegmentIndex:1];
    }
    if (![drug isEqualToString:CREATININE_CLEARNCE_ONLY]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    }
    // if called from the drug reference page, need to get rid of the toolbar
    [self.navigationController setToolbarHidden:YES];
    // see http://stackoverflow.com/questions/18967859/ios7-uiscrollview-offset-in-uinavigationcontroller
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ageField.delegate = self;
    weightField.delegate = self;
    creatinineField.delegate = self;
    
    [self registerForKeyboardNotifications];
    
 
 }

- (void)showNotes {
    [self performSegueWithIdentifier:@"DrugCalculatorNotesSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"DrugCalculatorNotesSegue"]) {
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"DrugCalculatorNotes";
    }
}

- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultWeightUnit = [defaults objectForKey:@"defaultweightunit"];
    self.defaultCreatinineUnit = [defaults objectForKey:@"defaultcreatinineunit"];
}

- (void)viewDidUnload
{

    [self setSexSegmentedControl:nil];
    [self setAgeField:nil];
    [self setWeightField:nil];
    [self setWeightUnitsSegmentedControl:nil];
    [self setCreatinineField:nil];
    [self setResultLabel:nil];
    [self setCreatinineUnitsSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (IBAction)toggleWeightUnits:(id)sender {
    //self.weightField.text  = nil;  this is bad if people enter weight first and then units, so it's gone.
    self.resultLabel.text = nil;
    [self setWeightPlaceholder:[sender selectedSegmentIndex]];
}

- (IBAction)toggleCrUnits:(id)sender {
    self.resultLabel.text = nil;
    [self setCrUnitsPlaceholder:[sender selectedSegmentIndex]];
}

- (void)setWeightPlaceholder:(NSInteger)index {
    NSString *placeholder = @"Weight (";
    if ((weightIsPounds = index == 0))
        self.weightField.placeholder = [placeholder stringByAppendingString:@"lb)"];
    else
        self.weightField.placeholder = [placeholder stringByAppendingString:@"kg)"];
}

- (void)setCrUnitsPlaceholder:(NSInteger)index {
    NSString *placeholder = @"Cr (";
    if ((unitsAreMgPerDl = index == 0))
        self.creatinineField.placeholder = [placeholder stringByAppendingString:@"mg/dL)"];
    else
        self.creatinineField.placeholder = [placeholder stringByAppendingString:@"µmol/L)"];
}

- (IBAction)toggleSex:(id)sender {
    self.resultLabel.text = nil;
}

- (IBAction)calculate:(id)sender {
    NSString *weightText = self.weightField.text;
    double weight = [weightText doubleValue];
    EPSLog(@"Weight is %f", weight);
    NSString *ageText = self.ageField.text;
    double age = [ageText doubleValue];
    EPSLog(@"Age is %f", age);
    NSString *creatinineText = self.creatinineField.text;
    double creatinine = [creatinineText doubleValue];
    EPSLog(@"Creatinine is %f", creatinine);
    // make sure all entries ok
    if (weight <= 0.0 || age <= 0.0 || creatinine <= 0.0) {
        self.resultLabel.text = @"INVALID ENTRY";
        return;
    }
    if (age < 18) {
        self.resultLabel.text = @"Pediatric dosing is not recommended or not calculated by EP Mobile.";
        return;
    }

    if (weightIsPounds) {
        EPSLog(@"Weight is in pounds (%f lb)", weight);
        weight = [self lbsToKgs:weight];
        EPSLog(@"Converted weight in kgs is %f", weight);
    }
    BOOL isMale = ([sexSegmentedControl selectedSegmentIndex] == 0);
    int cc = [self creatinineClearanceForAge:age isMale:isMale forWeightInKgs:weight forCreatinine:creatinine usingMicroMolUnits:!unitsAreMgPerDl];

    NSString *result = [[NSString alloc] init];
    if (!unitsAreMgPerDl)
        creatinine = [self creatinineFromMicroMolUnits:creatinine];
    result = [result stringByAppendingString:[self getDose:cc forWeightInKgs:weight forCreatinine:creatinine
                                                    forAge:age]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\nCreatinine Clearance = %i mL/min.", cc]];
    NSString *details = result;
    
    details = [details stringByAppendingString:@"\n"];
    details = [details stringByAppendingString:[self getDetails:cc forAge:age]];
    self.resultLabel.text = details;
    
    if ([self hasWarning:cc]) {
        NSString *alertTitle = @"Warning";
        [EPSSharedMethods showDialogWithTitle:alertTitle andMessage:details inView:self];
    }
    
    [self saveResultsWithAge:age isMale:isMale weightInKgs:weight creatinine:creatinine creatinineClearance:cc];
}

// weight is in kgs and creatinine in mg/dL always, which is good for drug references (same units)
- (void)saveResultsWithAge:(double)age isMale:(BOOL)isMale weightInKgs:(double)weight creatinine:(double)creatinine creatinineClearance:(double)creatinineClearance {
    EPSLog(@"Stored age is %f, sex is %d, weight is %f, creatinine is %f, creatinine clearance is %f", age, isMale, weight, creatinine, creatinineClearance);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:age forKey:@"CC_age"];
    [userDefaults setBool:isMale forKey:@"CC_is_male"];
    [userDefaults setDouble:weight forKey:@"CC_weight_in_kgs"];
    [userDefaults setDouble:creatinine forKey:@"CC_creatinine"];
    [userDefaults setDouble:creatinineClearance forKey:@"CC_creatinine_clearance"];
    // CC units?
    
}



- (IBAction)clear:(id)sender {
    self.ageField.text = nil;
    self.weightField.text = nil;
    self.creatinineField.text = nil;
    self.resultLabel.text = nil;
}

- (double)creatinineFromMicroMolUnits:(double)creatinine {
    return creatinine / 88.4;
}

- (int)creatinineClearanceForAge:(double)age isMale:(BOOL)isMale forWeightInKgs:(double)weight forCreatinine:(double)creatinine usingMicroMolUnits:(BOOL)usingMicroMolUnits {
    int result = 0;
    double crClr = 0.0;
    crClr = (140 - age) * weight;

    if (!usingMicroMolUnits) {
        crClr = crClr / (72 * creatinine);
        if (!isMale)
            crClr = crClr * 0.85;
        result = (int) (crClr + 0.5);
    }
    else {
        if (isMale)
            crClr = crClr * 1.2291;
        else
            crClr = crClr * 1.0447;
        crClr = crClr / creatinine;
        result = (int) (crClr + 0.5);
        
    }
    EPSLog(@"Unrounded crClr = %f, Rounded = %i", crClr, result);
    // don't return negative creatinine clearance
    return result < 0 ? 0 : result;
}


- (double)lbsToKgs:(double)weight{
    double CONVERSION_FACTOR = 0.45359237;
    return weight * CONVERSION_FACTOR;
}

// need more than just crCl for Apixaban dosing
- (NSString *)getDose:(int)crCl forWeightInKgs:(double)weight forCreatinine:(double)creatinine forAge:(double)age {
    int dose;
    NSString *message = [[NSString alloc] init];
    if ([drug isEqualToString:CREATININE_CLEARNCE_ONLY]) {
        message = @"";
        return message;
        
    }
    if ([drug isEqualToString:DABIGATRAN]) {
        if (crCl > 30)
            dose = 150;
        else if (crCl >= 15)
            dose = 75;
        else {
            dose = 0;
        }
        if (dose == 0)
            return [message stringByAppendingString:DO_NOT_USE];
        return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg BID. ", dose]];
        
    }
    if ([drug isEqualToString:DOFETILIDE]) {
 		if (crCl > 60)
			dose = 500;
		else if (crCl >= 40)
			dose = 250;
		else if (crCl >= 20)
			dose = 125;
		else 
            dose = 0;
        if (dose == 0)
            return [message stringByAppendingString:DO_NOT_USE];
        return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mcg BID. ", dose]];
    }
    if ([drug isEqualToString:RIVAROXABAN]) {
        if (crCl > 50)
            dose = 20;
        else if (crCl >= 15)
            dose = 15;
        else
            dose = 0;
        if (dose == 0)
            return [message stringByAppendingString:DO_NOT_USE];
        return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg daily. ", dose]];        
        }
    if ([drug isEqualToString:SOTALOL]) {
        if (crCl >= 40)
            dose = 80;
        else 
            dose = 0;
        if (dose == 0)
            return [message stringByAppendingString:DO_NOT_USE];
        if (crCl > 60)
            return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg BID. ", dose]];
        if (crCl >= 40)
            return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg daily. ", dose]];  
    }
    if ([drug isEqualToString:APIXABAN]) {
        NSString* stringDose = @"";
        
            EPSLog(@"Creatine = %f", creatinine);
            if ((creatinine >= 1.5 && (age >= 80 || weight <= 60))
                    || (age >= 80 && weight <= 60))
                stringDose = @"2.5";
            else
                stringDose = @"5";
        
        if ([stringDose isEqualToString:@"0"])
            return [message stringByAppendingString:DO_NOT_USE];
        message = [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %@ mg BID. ", stringDose]];
        if ([stringDose isEqualToString:@"2.5"])
            message = [message stringByAppendingString:APIXABAN_2_5_CAUTION];
        else
            message = [message stringByAppendingString:APIXABAN_5_CAUTION];
        
        message = [message stringByAppendingString:INHIBITORS];
        if (crCl < 15) {
            message = [message stringByAppendingString:APIXABAN_ESRD_CAUTION];
        }
        return message;
    }
    if ([drug isEqualToString:EDOXABAN]) {
        NSString* stringDose = @"";
        if (crCl < 15 || crCl > 95)
            stringDose = @"0";
        else {
            EPSLog(@"Creatine = %f", creatinine);
            if (crCl <= 50 && crCl >= 15)
                stringDose = @"30";
            else
                stringDose = @"60";
        }
        if ([stringDose isEqualToString:@"0"])
            return [message stringByAppendingString:DO_NOT_USE];
        message = [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %@ mg daily. ", stringDose]];
        return message;
        //return [message stringByAppendingString:AFB_DOSING_ONLY_WARNING];
    }
    return @"Unknown Dose";
}

- (BOOL)hasWarning:(int)crCl {
    if ([drug isEqualToString:DABIGATRAN])
        return crCl <= 50;
    if ([drug isEqualToString:DOFETILIDE])
        return crCl < 20;
    if ([drug isEqualToString:RIVAROXABAN])
        return crCl < 15;
    if ([drug isEqualToString:SOTALOL])
        return crCl < 40;
    if ([drug isEqualToString:APIXABAN])
        return crCl < 15;
    if ([drug isEqualToString:EDOXABAN])
        return (crCl <15 || crCl > 95);
    return NO;
}

- (NSString *)getDetails:(int)crCl forAge:(double)age {
    if ([drug isEqualToString:DABIGATRAN]) {
        NSString *message = @"";
        if (crCl < 15)
            return message;
        if (crCl <= 30)
            message = @"Avoid concomitant use of P-gp inhibitors (e.g. dronedarone).";
        else if (crCl <= 50)
            message = @"Consider reducing dose to 75 mg BID "
                "when using with dronedarone or systemic ketoconazole.";
        if (age >= 75.0)
            message = [message stringByAppendingString:@" Possible increased bleeding risk (age > 75 y)."];
        return message;
        
    }
    if ([drug isEqualToString:DOFETILIDE]) {
        if (crCl <= 20)
            return @"";
    }
    if ([drug isEqualToString:RIVAROXABAN]) {
        if (crCl < 15)
            return @"";
        else 
            return @"Take dose with evening meal.";
    }
    if ([drug isEqualToString:SOTALOL]) {
        if (crCl < 40)
            return @"";
        else {
            NSString * msg = @"Recommended starting dose for treatment of atrial fibrillation. "
                "Initial QT should be < 450 msec. "
                "If QT remains < 500 msec dose can be increased to 120 mg or 160 mg ";
            if (crCl > 60)
                return [msg stringByAppendingString:@"BID."];
            else 
                return [msg stringByAppendingString:@"daily."];
        }
    }
    if ([drug isEqualToString:EDOXABAN]) {
        if (crCl < 15) {
            return @"";
        }
        else if (crCl > 95) {
            return @"Edoxaban should not be used in patients with CrCl > 95 mL/min";
        }
    }
    return @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
//
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.scrollView.frame;
//                         originalBounds = frame;
//                         frame.origin.y = -80;
//                         self.scrollView.frame = frame;
//
//                     }
//                     completion:nil];

    NSDictionary* info = [aNotification userInfo];
    NSLog(@"Keyboard will be shown");
    // see https://stackoverflow.com/questions/45689664/ios-11-keyboard-height-is-returning-0-in-keyboard-notification
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    NSLog(@"keyboardWillBeHidden");

//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
////                         CGRect frame = self.scrollView.frame;
////                         frame.origin.y = 50;
//                         self.scrollView.frame = originalBounds;
//
//                     }
//                     completion:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


@end
