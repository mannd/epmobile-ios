//
//  EPSDrugDoseCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSDrugDoseCalculatorViewController.h"

@interface EPSDrugDoseCalculatorViewController ()

@end

@implementation EPSDrugDoseCalculatorViewController
@synthesize sexSegmentedControl;
@synthesize ageField;
@synthesize weightField;
@synthesize weightUnitsSegmentedControl;
@synthesize creatinineField;
@synthesize resultField;
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
}

- (void)viewDidUnload
{

    [self setSexSegmentedControl:nil];
    [self setAgeField:nil];
    [self setWeightField:nil];
    [self setWeightUnitsSegmentedControl:nil];
    [self setCreatinineField:nil];
    [self setResultField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)calculate:(id)sender {
}

- (IBAction)clear:(id)sender {
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [ageField resignFirstResponder];
    [weightField resignFirstResponder];
    [creatinineField resignFirstResponder];
}

@end
