//
//  EPSQTcCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/16/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSQTcCalculatorViewController.h"
#import "EPSQTMethods.h"
#import "EPSLogging.h"

// Formula picker must match below,
// but constants now defined in EPSQTMethods.h
//#define BAZETT 0
//#define FRIDERICIA 1
//#define SAGIE 2
//#define HODGES 3

#define MAX_NORMAL_QTC 440.0

#define RATE_INDEX 0
#define INTERVAL_INDEX 1

#define DEFAULT_QTC_FORMULA_KEY @"defaultqtcformula"
#define MAXIMUM_QTC_KEY @"maximumqtc"
#define INTERVAL_OR_RATE_KEY @"intervalorrate"
//#define RATE_KEY @"

#define INVALID_ENTRY @"INVALID ENTRY"

@interface EPSQTcCalculatorViewController ()

@end

@implementation EPSQTcCalculatorViewController
{
    BOOL inputIsRate;
}
@synthesize formulaPicker;
@synthesize formulaData;
@synthesize inputField;
@synthesize qtField;
@synthesize resultLabel;
@synthesize defaultQTcFormula;
@synthesize maxQTc;
@synthesize defaultInputTypeIsInterval;
@synthesize intervalRateSegmentedControl;

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
    inputIsRate = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self refreshDefaults];
    if (self.defaultInputTypeIsInterval) {
        [self setInputType:INTERVAL_INDEX];
        [intervalRateSegmentedControl setSelectedSegmentIndex:INTERVAL_INDEX];
    }
    else {
        [self setInputType:RATE_INDEX];
        [intervalRateSegmentedControl setSelectedSegmentIndex:RATE_INDEX];
    }


}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.defaultQTcFormula isEqualToString:@"Bazett"])
        [formulaPicker selectRow:0 inComponent:0 animated:NO];
    else if ([self.defaultQTcFormula isEqualToString:@"Fridericia"])
        [formulaPicker selectRow:1 inComponent:0 animated:YES];
    else if ([self.defaultQTcFormula isEqualToString:@"Sagie"])
        [formulaPicker selectRow:2 inComponent:0 animated:YES];
    else if ([self.defaultQTcFormula isEqualToString:@"Hodges"])
        [formulaPicker selectRow:3 inComponent:0 animated:YES];
}

- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultQTcFormula = [defaults objectForKey:DEFAULT_QTC_FORMULA_KEY];
    NSString *maxQTcString = [defaults objectForKey:MAXIMUM_QTC_KEY];
    NSString *defaultIntervalOrRate = [defaults objectForKey:INTERVAL_OR_RATE_KEY];
    // If defaults aren't loaded this defaults to a default input type
    // of RATE which is what we want.
    self.defaultInputTypeIsInterval = ([defaultIntervalOrRate isEqualToString:@"interval"]);
    self.maxQTc = [maxQTcString floatValue];
    // this ensures maxQTc is sane if defaults aren't loaded
    if (self.maxQTc == 0.0)
        self.maxQTc = MAX_NORMAL_QTC;
    EPSLog(@"MaxQTcString = %@", maxQTcString);
    EPSLog(@"MaxQTc = %f", self.maxQTc);
    
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.inputField resignFirstResponder];
    [self.qtField resignFirstResponder];
}

- (IBAction)calculateButtonPressed:(id)sender {
    NSString *input = self.inputField.text;
    NSInteger inputNumber = [input intValue];
    EPSLog(@"The value of inputNumber is %ld", (long)inputNumber);
    NSString *qt = self.qtField.text;
    NSInteger qtNumber = [qt intValue];
    EPSLog(@"The value of qtNumber is %ld", (long)qtNumber);
    if (inputNumber <= 0 || qtNumber <= 0) {
        if (@available(iOS 13.0, *)) {
            self.resultLabel.textColor = [UIColor labelColor];
        } else {
            self.resultLabel.textColor = [UIColor darkTextColor];
        }
        self.resultLabel.text = INVALID_ENTRY;
        return;
    }
    if (inputIsRate) {
        inputNumber = 60000.0 / inputNumber;
        EPSLog(@"Converted to RR interval in msec is %ld", (long)inputNumber);
    }
    NSInteger row = [formulaPicker selectedRowInComponent:0];
    NSString *formula = [formulaData objectAtIndex:row];
    EPSLog(@"Formula is %@", formula);
    EPSLog(@"Row is %ld", (long)row);
    NSInteger qtc = [EPSQTMethods qtcFromQtInMsec:qtNumber AndIntervalInMsec:inputNumber UsingFormula:(QTFormula)row];

    EPSLog(@"QTc = %ld", (long)qtc);
    if (qtc == 0.0) {
        if (@available(iOS 13.0, *)) {
            self.resultLabel.textColor = [UIColor labelColor];
        } else {
            self.resultLabel.textColor = [UIColor darkTextColor];
        }
        self.resultLabel.text = INVALID_ENTRY;
    }
    else {
        if (qtc > self.maxQTc)
            self.resultLabel.textColor = [UIColor systemRedColor];
        else
            if (@available(iOS 13.0, *)) {
                self.resultLabel.textColor = [UIColor labelColor];
            } else {
                self.resultLabel.textColor = [UIColor darkTextColor];
            }
        self.resultLabel.text = [[NSString alloc] initWithFormat:@"QTc is %li msec (%@ formula)", (long)qtc, formula];
        // result text color
    }
    //self.resultLabel.text = resultString;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.inputField.text = nil;
    self.qtField.text = nil;
    self.resultLabel.text = nil;
}


- (IBAction)toggleInputType:(id)sender {
    self.inputField.text = nil;
    self.resultLabel.text = nil;
    // 0 == Rate
    [self setInputType:[sender selectedSegmentIndex]];
}

- (void)setInputType:(NSInteger)index {
    if ((inputIsRate = index == RATE_INDEX))
        self.inputField.placeholder = @"Heart Rate (bpm)";
    else
        self.inputField.placeholder = @"RR Interval (msec)";
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
