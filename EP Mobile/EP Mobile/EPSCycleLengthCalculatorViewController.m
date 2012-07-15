//
//  EPSCycleLengthCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCycleLengthCalculatorViewController.h"

@interface EPSCycleLengthCalculatorViewController ()


@end

@implementation EPSCycleLengthCalculatorViewController
@synthesize inputField;
@synthesize resultLabel;
@synthesize resultUnits;
@synthesize resultPrefix;
@synthesize inputLabel;

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
    [self setupCL];
}

- (void)viewDidUnload
{
    [self setInputField:nil];
    [self setResultLabel:nil];
    [self setInputLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)calculateButton:(id)sender {
    NSString *s = self.inputField.text;
    int n = [s intValue];
    if (n == 0) {
        self.resultLabel.text = @"INVALID ENTRY";
        return;
    }
    int result = 60000 / n;
    NSString *resultString = resultPrefix;
    resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%d ", result]];
    resultString = [resultString stringByAppendingString:self.resultUnits];
    self.resultLabel.text = resultString;					
}


- (IBAction)clearButton:(id)sender {
    self.inputField.text = nil;
    self.resultLabel.text = nil;
}



- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.inputField resignFirstResponder];
}

- (IBAction)toggleSwitch:(id)sender {
    self.inputField.text = nil;
    self.resultLabel.text = nil;
    // 0 == CL
    if ([sender selectedSegmentIndex] == 0) {
        [self setupCL];
    }
    else {
        [self setupHR];
    }
}

- (void)setupHR {
    [self setResultPrefix:@"Cycle Length is " andUnits:@"msec" andPlaceholder:@"HR (bpm)" andInputLabel:@"Enter Heart Rate in bpm:"];   
}

- (void)setupCL {
    [self setResultPrefix:@"Heart Rate is " andUnits:@"bpm" andPlaceholder:@"CL (msec)"andInputLabel:@"Enter Cycle Length in msec:"];    
}

- (void)setResultPrefix:(NSString *)prefix andUnits:(NSString *)units andPlaceholder:(NSString *)placeholder andInputLabel:(NSString *)inputText {
    self.inputField.placeholder = placeholder;
    self.resultPrefix = prefix;
    self.resultUnits = units;
    self.inputLabel.text = inputText;
}

@end
