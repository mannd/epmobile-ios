//
//  EPSCycleLengthCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCycleLengthCalculatorViewController.h"
#import "EPSLogging.h"


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

- (int)convertInterval:(int)n {
    // make sure result rounded up to nearest msec
    return (int)round(60000.0 / n);
}

- (IBAction)calculateButton:(id)sender {
    NSString *s = self.inputField.text;
    int n = [s intValue];
    EPSLog(@"The value of n is %i", n);
    if (n == 0) {
        self.resultLabel.text = @"INVALID ENTRY";
        return;
    }
    int result;
    result = [self convertInterval:n];
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
    [self setResultPrefix:@"Interval is " andUnits:@"msec" andPlaceholder:@"Rate (bpm)" andInputLabel:@"Rate (bpm)" andTitle:@"Rate ➜ Interval"];   
}

- (void)setupCL {
    [self setResultPrefix:@"Rate is " andUnits:@"bpm" andPlaceholder:@"Interval (msec)"andInputLabel:@"Interval (msec)" andTitle:@"Interval ➜ Rate"];    
}

- (void)setResultPrefix:(NSString *)prefix andUnits:(NSString *)units andPlaceholder:(NSString *)placeholder andInputLabel:(NSString *)inputText andTitle:(NSString *)title {
    self.inputField.placeholder = placeholder;
    self.resultPrefix = prefix;
    self.resultUnits = units;
    self.inputLabel.text = inputText;
    self.navigationItem.title = title;
}

@end
