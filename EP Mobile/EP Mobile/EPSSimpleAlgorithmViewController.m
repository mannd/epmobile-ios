//
//  EPSSimpleAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSSimpleAlgorithmViewController.h"

#define OUTFLOW_VT @"OutflowVT"
#define ANNULAR_VT @"AnnularVT"

@interface EPSSimpleAlgorithmViewController ()

@end

@implementation EPSSimpleAlgorithmViewController
@synthesize algorithm;

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
    if ([self.algorithm isEqualToString:OUTFLOW_VT])
        self.navigationItem.title = @"Outflow Tract VT Location";
    else if ([self.algorithm isEqualToString:ANNULAR_VT])
        self.navigationItem.title = @"Mitral Annular VT Location";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
