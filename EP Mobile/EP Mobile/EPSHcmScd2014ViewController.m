//
//  EPSHcmScd2014ViewController.m
//  EP Mobile
//
//  Created by David Mann on 5/30/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSHcmScd2014ViewController.h"
#import "EPSRiskScore.h"
#import "EPSNotesViewController.h"
#import "EPSLogging.h"

#define COPY_RESULT_BUTTON_NUMBER 1
#define TITLE @"HCM SCD 2014"
#define FULL_REFERENCE @"O’Mahony C., Jichi F., Pavlou M., Monserrat L., Anastasakis A., Rapezzi C.  A novel clinical risk prediction model for sudden cardiac death in hypertrophic cardiomyopathy (HCM Risk-SCD). Eur Heart J [Internet] 2014 Aug [cited 2015 May 29];35(30):2010–2020. Available from: http://doi.org/10.1093/eurheartj/eht439"

@interface EPSHcmScd2014ViewController ()

@end

@implementation EPSHcmScd2014ViewController {
    UITextField *activeField;
}

static const int NO_ERROR = 8999;
static const int NUMBER_EXCEPTION = 9000;
static const int AGE_OUT_OF_RANGE = 9001;
static const int THICKNESS_OUT_OF_RANGE = 9002;
static const int GRADIENT_OUT_OF_RANGE = 9003;
static const int SIZE_OUT_OF_RANGE = 9004;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = TITLE;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.risks = array;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.ageTextField resignFirstResponder];
    [self.thicknessTextField resignFirstResponder];
    [self.sizeTextField resignFirstResponder];
    [self.gradientTextField resignFirstResponder];
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"HcmScd2014NotesSegue" sender:nil];
}

- (IBAction)calculate:(id)sender {
    int errorCode = NO_ERROR;
    NSInteger age = [self textFieldToInt:self.ageTextField];
    NSInteger thickness = [self textFieldToInt:self.thicknessTextField];
    NSInteger size = [self textFieldToInt:self.sizeTextField];
    NSInteger gradient = [self textFieldToInt:self.gradientTextField];
    // TODO user will be confused if zero gradient entered, and error message isn't clear
    // that the range is 2 to whatever... What to do??
    // Maybe put range in hint
    BOOL hasFamilyHxScd = self.familyHxSwitch.on;
    BOOL hasNsvt = self.nsvtSwitch.on;
    BOOL hasSyncope = self.syncopeSwitch.on;
    if (age <= 0 || thickness <= 0 || size <= 0 || gradient <= 0) {
        errorCode = NUMBER_EXCEPTION;
    }
    else if (age > 115 || age < 16) {
        errorCode = AGE_OUT_OF_RANGE;
    }
    else if (thickness < 10 || thickness > 35) {
        errorCode = THICKNESS_OUT_OF_RANGE;
    }
    else if (size < 28 || size > 67) {
        errorCode = SIZE_OUT_OF_RANGE;
    }
    else if (gradient < 2 || gradient > 154) {
        errorCode = GRADIENT_OUT_OF_RANGE;
    }
    if (errorCode != NO_ERROR) {
        [self showErrorDialog:errorCode];
        return;
    }
    double coefficient = 0.998;
    double prognosticIndex = 0.15939858 * thickness
    - 0.00294271 * thickness * thickness
    + 0.0259082 * size
    + 0.00446131 * gradient
    + (hasFamilyHxScd ? 0.4583082 : 0.0)
    + (hasNsvt ? 0.82639195 : 0.0)
    + (hasSyncope ? 0.71650361 : 0.0)
    - 0.01799934 * age;
    double scdProb = 1 - pow(coefficient, exp(prognosticIndex));
    EPSLog(@"scdProb = %f", scdProb);
    [self.risks removeAllObjects];
    [self.risks addObject:[NSString stringWithFormat:@"Age = %ld yrs", (long)age]];
    [self.risks addObject:[NSString stringWithFormat:@"Max LV wall thickness = %ld mm", (long)thickness]];
    [self.risks addObject:[NSString stringWithFormat:@"Max LA diameter = %ld mm", (long)size]];
    [self.risks addObject:[NSString stringWithFormat:@"Max LVOT gradient = %ld mmHg", (long)gradient]];
    if (hasFamilyHxScd) {
        [self.risks addObject:@"Family hx of SCD"];
    }
    if (hasNsvt) {
        [self.risks addObject:@"NSVT"];
    }
    if (hasSyncope) {
        [self.risks addObject:@"Hx of unexplained syncope"];
    }
    [self showResultDialog:scdProb];
}

- (NSInteger)textFieldToInt:(UITextField *)textField {
    return [textField.text integerValue];
}

- (void)showErrorDialog:(NSInteger)errorCode {
    NSString *title = @"Error";
    NSString *message;
    switch (errorCode) {
        case NUMBER_EXCEPTION:
            message = @"One or more entries are invalid.";
            break;
        case AGE_OUT_OF_RANGE:
            message = @"Age must be between 16 and 115 years.";
            break;
        case THICKNESS_OUT_OF_RANGE:
            message = @"Maximum LV wall thickness must be between 10 and 35 mm.";
            break;
        case SIZE_OUT_OF_RANGE:
            message = @"Maximum LA diameter must be between 28 and 67 mm.";
            break;
        case GRADIENT_OUT_OF_RANGE:
            message = @"Maximum LV outflow tract gradient must between 2 and 154 mmHg.";
            break;
        case NO_ERROR:  // fall through, and shouldn't be here anyway
        default:
            return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (NSString *)getFullRiskReport:(NSString *)message {
    NSString *riskList = [EPSRiskScore formatRisks:self.risks];
    NSString *report = @"Risk score: ";
    report = [report stringByAppendingString:TITLE];
    report = [report stringByAppendingString:@"\nRisks: "];
    report = [report stringByAppendingString:riskList];
    report = [report stringByAppendingString:@"\n"];
    report = [report stringByAppendingString:message];
    report = [report stringByAppendingString:@"\nReference: "];
    report = [report stringByAppendingString:FULL_REFERENCE];
    report = [report stringByAppendingString:@"\n"];
    // eliminate blank lines
    report = [report stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    return report;
}

- (void)showResultDialog:(double)prob {
    // make it a percentage
    prob = prob * 100.0;
    NSString *title = @"HCM-SCD Risk";
    NSString *riskMessage = [NSString stringWithFormat:@"5 year SCD Risk = %2.2f%%", prob];
    NSString *recommendation;
    if (prob < 4) {
        recommendation = @"\nICD generally not indicated.";
    }
    else if (prob < 6) {
        recommendation = @"\nICD may be considered.";
    }
    else {
        recommendation = @"\nICD should be considered.";
    }
    NSString *message = [riskMessage stringByAppendingString:recommendation];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Copy Result", nil];
    [alertView show];
}

- (IBAction)clear:(id)sender {
    self.ageTextField.text = nil;
    self.thicknessTextField.text = nil;
    self.sizeTextField.text = nil;
    self.gradientTextField.text = nil;
    [self.familyHxSwitch setOn:NO animated:YES];
    [self.nsvtSwitch setOn:NO animated:YES];
    [self.syncopeSwitch setOn:NO animated:YES];
    [self.risks removeAllObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = @"HcmScd2014";
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == COPY_RESULT_BUTTON_NUMBER) {
        NSString* result = [self getFullRiskReport:[alertView message]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
    }
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

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
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
