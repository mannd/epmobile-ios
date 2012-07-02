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
}

- (void)viewDidUnload
{
    [self setInputField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)calculateButton:(id)sender {
    NSString *s = inputField.text;
    int n = [s intValue];
    if (n == 0) {
        resultLabel.text = @"Invalid Entry";
        return;
    }
    int result = 60000 / n;
    resultLabel.text = [NSString stringWithFormat:@"%d", result];    					
}


- (IBAction)clearButton:(id)sender {
    inputField.text = nil;
    resultLabel.text = nil;
}



- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [inputField resignFirstResponder];
}

- (IBAction)toggleSwitch:(id)sender {
    inputField.text = nil;
    resultLabel.text = nil;
}

@end
