//
//  EPSQTcCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/16/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSQTcCalculatorViewController.h"

#define BAZETT 0
#define FRIDERICIA 1
#define SAGIE 2
#define HODGES 3

@interface EPSQTcCalculatorViewController ()

@end

@implementation EPSQTcCalculatorViewController
@synthesize formulaPicker;
@synthesize formulaData;
@synthesize inputField;
@synthesize qtField;
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
    NSArray *array = [[NSArray alloc] initWithObjects:@"Bazett", @"Fridericia", @"Sagie", @"Hodges", nil];
    self.formulaData = array;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setInputField:nil];
    [self setQtField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.formulaPicker = nil;
    self.formulaData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.inputField resignFirstResponder];
    [self.qtField resignFirstResponder];
}

- (IBAction)calculateButtonPressed:(id)sender {
}

- (IBAction)clearButtonPressed:(id)sender {
    self.inputField.text = nil;
    self.qtField.text = nil;
}

- (IBAction)toggleInputType:(id)sender {
    self.inputField.text = nil;
    self.resultLabel.text = nil;
    // 0 == Rate
    if ([sender selectedSegmentIndex] == 0) {
        self.inputField.placeholder = @"Heart Rate (bpm)";
    }
    else {
        self.inputField.placeholder = @"RR Interval (msec)";
    }
}


#pragma mark - Formula Picker Data Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [formulaData count];
}


# pragma mark - Formula Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [formulaData objectAtIndex:row];
}
@end
