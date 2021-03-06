//
//  EPSDateCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSDateCalculatorViewController.h"
#import "EPSNotesViewController.h"
#import "EPSLogging.h"

#define INVALID_ENTRY @"INVALID ENTRY!"

@interface EPSDateCalculatorViewController ()

@end

@implementation EPSDateCalculatorViewController

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
    [_numberOfDaysTextField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange {
    [self clearResult];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.numberOfDaysTextField resignFirstResponder];
}
- (IBAction)subtractDaysValueChanged:(id)sender {
    [self clearResult];
}
- (IBAction)startingDateValueChanged:(id)sender {
    [self clearResult];
}

- (IBAction)changeNumberOfDays:(id)sender {
    NSInteger selection = [sender selectedSegmentIndex];
    switch(selection) {
        case 0:
            [self.numberOfDaysTextField setText:@"90"];
            break;
        case 1:
            [self.numberOfDaysTextField setText:@"40"];
            break;
        case 2:
            [self.numberOfDaysTextField setText:@"30"];
            break;
    }
    [self clearResult];
}

- (IBAction)calculate:(id)sender {
    NSString *numberOfDays = self.numberOfDaysTextField.text;
    NSInteger days = [numberOfDays intValue];
    EPSLog(@"Formula is %ld", (long)days);
    if (days == 0) { // either zero entered or bad stuff entered
        [self.resultLabel setText:INVALID_ENTRY];
        return;
    }
    NSDate *date = [self.datePicker date];
    BOOL subtract = self.subtractDaysSwitch.on;
    if (subtract)
        days = - days;
    NSTimeInterval interval = days * 24 * 60 * 60;
    NSDate *resultDate = [date dateByAddingTimeInterval:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
      
    NSString *formattedDateString = [dateFormatter stringFromDate:resultDate];
    
    [self.resultLabel setText:formattedDateString];

}

- (IBAction)clear:(id)sender {
    [self clearResult];
    self.numberOfDaysTextField.text = @"90";
    self.daysSegmentedControl.selectedSegmentIndex = 0;
}

- (void)clearResult {
    self.resultLabel.text = @"Date";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = @"DateCalculatorNotes";
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"DateCalculatorNotesSegue" sender:nil];
}

@end
