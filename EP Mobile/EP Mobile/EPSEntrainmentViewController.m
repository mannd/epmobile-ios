//
//  EPSEntrainmentViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSEntrainmentViewController.h"
#import "EPSNotesViewController.h"

#define INVALID_WARNING @"INVALID ENTRY"

@interface EPSEntrainmentViewController ()

@end

@implementation EPSEntrainmentViewController {
    UITextField *activeField;
}

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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    self.sqrsTextField.enabled = NO;
    self.egqrsTextField.enabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerForKeyboardNotifications];
    
    self.sqrsTextField.delegate = self;
    self.egqrsTextField.delegate = self;
    self.tclTextField.delegate = self;
    self.ppiTextField.delegate = self;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTclTextField:nil];
    [self setPpiTextField:nil];
    [self setConcealedFusionSwitch:nil];
    [self setSqrsLabel:nil];
    [self setSqrsTextField:nil];
    [self setEgqrsLabel:nil];
    [self setEgqrsTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
}
- (IBAction)calculate:(id)sender {
    NSString *tclString = self.tclTextField.text;
    NSString *ppiString = self.ppiTextField.text;
    NSString *sqrsString = self.sqrsTextField.text;
    NSString *egqrsString = self.egqrsTextField.text;
    NSInteger tcl = [tclString integerValue];
    NSInteger ppi = [ppiString integerValue];
    
    NSString *message = @"";
    
    
    NSInteger ppiMinusTcl = ppi - tcl;
    if (ppiMinusTcl < 0 || tcl <= 0 || ppi <= 0) {
        self.resultLabel.text = INVALID_WARNING;
        return;
    }
    if (!self.concealedFusionSwitch.on) {
        if (ppiMinusTcl > 30)
            message = @"Remote site from reentry circuit.";
        else
            message = @"Outer loop of reentry circuit.";
    } else { // concealed fusion present!
        if (ppiMinusTcl > 30) {
            message = @"Adjacent bystander pathway not in reentry circuit.";
        } else {
            message = @"Inner loop or isthmus site of reentry circuit.";
            NSInteger egqrs = 0;
            NSInteger sqrs = 0;
            BOOL hasEgqrs = NO;
            BOOL hasSqrs = NO;
            BOOL invalidSqrs = NO;
            if (self.egqrsTextField.text.length != 0) {
                egqrs = [egqrsString integerValue];
                hasEgqrs = YES;
            }
            if (self.sqrsTextField.text.length != 0) {
                sqrs = [sqrsString integerValue];
                hasSqrs = YES;
            }
            if (hasSqrs) {
                double sqrsPercent = (double) sqrs / tcl;
                message = [message stringByAppendingString:@" "];
                if (sqrsPercent < 0.3)
                    message = [message stringByAppendingString:@"Isthmus exit site."];
                else if (sqrsPercent <= 0.5)
                    message = [message stringByAppendingString:@"Isthmus central site."];
                else if (sqrsPercent <= 0.7)
                    message = [message stringByAppendingString:@"Isthmus proximal site."];
                else if (sqrsPercent <= 1.0)
                    message = [message stringByAppendingString:@"Inner loop site."];
                else {
                    message = [message stringByAppendingString:@"Invalid S-QRS (<TCL) ignored!"];
                    invalidSqrs = YES;
                }
                if (hasEgqrs && !invalidSqrs) {
                    NSInteger egMinusQrs = egqrs - sqrs;
                    message = [message stringByAppendingString:@" "];
                    if (abs((int)egMinusQrs) <= 20)
                        message = [message stringByAppendingString:@"Similar S-QRS and EG-QRS intervals suggest site in isthmus of reentry circuit."];
                    else
                        message = [message stringByAppendingString:@"Dissimilar S-QRS and EG-QRS intervals suggest site may be an adjacent bystander."];
                }
            }
        }
    }
    NSString *finalResult = @"PPI-TCL = ";
    NSString *ppiMinusTclString = [NSString stringWithFormat:@"%ld. ", (long)ppiMinusTcl];
    finalResult = [finalResult stringByAppendingString:ppiMinusTclString];
    finalResult = [finalResult stringByAppendingString:message];
    self.resultLabel.text = finalResult;
        
}

- (IBAction)clearAll:(id)sender {
    [self clear:sender];
    self.tclTextField.text = nil;
}

- (IBAction)clear:(id)sender {
    self.ppiTextField.text = nil;
    self.concealedFusionSwitch.on = NO;
    self.sqrsLabel.enabled = NO;
    self.egqrsLabel.enabled = NO;
    self.sqrsTextField.enabled = NO;
    self.egqrsTextField.enabled = NO;
    self.sqrsTextField.text = nil;
    self.egqrsTextField.text = nil;
    self.resultLabel.text = nil;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = @"EntrainmentNotes";
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"EntrainmentNotesSegue" sender:nil];
}


- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.tclTextField resignFirstResponder];
    [self.ppiTextField resignFirstResponder];
    [self.sqrsTextField resignFirstResponder];
    [self.egqrsTextField resignFirstResponder];
}

- (IBAction)concealedFusionSwitchValueChanged:(id)sender {
    BOOL switchOn = self.concealedFusionSwitch.on;
    self.sqrsTextField.enabled = switchOn;
    self.sqrsLabel.enabled = switchOn;
    self.egqrsTextField.enabled = switchOn;
    self.egqrsLabel.enabled = switchOn;
    // Clear these fields every time the switch is switched,
    // won't matter when turning switch on, but easier not to check this.
    self.sqrsTextField.text = nil;
    self.egqrsTextField.text = nil;
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
