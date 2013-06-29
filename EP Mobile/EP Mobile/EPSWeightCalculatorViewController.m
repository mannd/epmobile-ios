//
//  EPSWeightCalculatorViewController.m
//  EP Mobile
//
//  Created by David Mann on 6/29/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSWeightCalculatorViewController.h"

@interface EPSWeightCalculatorViewController ()

@end

@implementation EPSWeightCalculatorViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSexSegementedControl:nil];
    [self setWeightUnitsSegmentedControl:nil];
    [self setHeightUnitsSegmentedControl:nil];
    [self setWeightTextField:nil];
    [self setHeightTextField:nil];
    [self setAbwLabel:nil];
    [self setIbwLabel:nil];
    [self setIbwResultLabel:nil];
    [self setAbwResultLabel:nil];
    [super viewDidUnload];
}
- (IBAction)calculate:(id)sender {
}

- (IBAction)clear:(id)sender {
}
- (IBAction)copyIbw:(id)sender {
}

- (IBAction)copyAbw:(id)sender {
}
@end
