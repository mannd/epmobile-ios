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
@synthesize drugPicker;
@synthesize drugPickerData;

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
    NSArray *array = [[NSArray alloc] initWithObjects:@"Dabigatran", @"Dofetilide", @"Rivaroxaban", @"Sotalol", nil];
    self.drugPickerData = array;
}

- (void)viewDidUnload
{
    [self setDrugPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.drugPicker = nil;
    self.drugPickerData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [drugPickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [drugPickerData objectAtIndex:row];
}

@end
