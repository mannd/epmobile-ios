//
//  EPSDosingTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSDosingTableViewController.h"

@interface EPSDosingTableViewController ()

@end

@implementation EPSDosingTableViewController
@synthesize tueDose1;
@synthesize tueDose2;
@synthesize wedDose1;
@synthesize wedDose2;
@synthesize thuDose1;
@synthesize thuDose2;
@synthesize friDose1;
@synthesize friDose2;
@synthesize satDose1;
@synthesize satDose2;
@synthesize titleBar;
@synthesize titleLabel;
@synthesize lowChangeLabel;
@synthesize highChangeLabel;
@synthesize sunDose1;
@synthesize sunDose2;
@synthesize monDose1;
@synthesize monDose2;
@synthesize tabletSize;
@synthesize lowEnd;
@synthesize highEnd;
@synthesize increase;
@synthesize weeklyDose;

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
    NSString *title = [[NSString alloc] initWithFormat:@"Warfarin Dosing (%g mg tab)", self.tabletSize];
    self.titleBar.title = title;
}

- (void)viewDidUnload
{
    [self setSunDose1:nil];
    [self setSunDose2:nil];
    [self setMonDose1:nil];
    [self setMonDose2:nil];
    [self setTueDose1:nil];
    [self setTueDose2:nil];
    [self setWedDose1:nil];
    [self setWedDose2:nil];
    [self setThuDose1:nil];
    [self setThuDose2:nil];
    [self setFriDose1:nil];
    [self setFriDose2:nil];
    [self setSatDose1:nil];
    [self setSatDose2:nil];
    [self setTitleLabel:nil];
    [self setTitleBar:nil];
    [self setLowChangeLabel:nil];
    [self setHighChangeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
