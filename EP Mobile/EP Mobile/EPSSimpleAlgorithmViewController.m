//
//  EPSSimpleAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSSimpleAlgorithmViewController.h"
#import "EPSBrugadaNotesViewController.h"

#define OUTFLOW_VT @"OutflowVT"
#define ANNULAR_VT @"AnnularVT"

@interface EPSSimpleAlgorithmViewController ()

@end

@implementation EPSSimpleAlgorithmViewController
@synthesize algorithm;
@synthesize backButton;
@synthesize instructionsButton;
@synthesize questionLabel;

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
    // ...
    // disabled buttons aren't automatically grayed out in iOS
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.backButton.enabled = NO;
    if ([self.algorithm isEqualToString:OUTFLOW_VT] || [self.algorithm isEqualToString:ANNULAR_VT]) {
        self.instructionsButton.hidden = NO;
        [self.instructionsButton setTitle:
         @"Instructions" forState:UIControlStateNormal];
    }
    else
        self.instructionsButton.hidden = YES;
    
}

- (void)viewDidUnload
{
    self.algorithm = nil;
    [self setBackButton:nil];
    [self setQuestionLabel:nil];
    [self setInstructionsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)yesButtonPushed:(id)sender {
}

- (IBAction)noButtonPushed:(id)sender {
}

- (IBAction)backButtonPushed:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSBrugadaNotesViewController *vc = (EPSBrugadaNotesViewController *)[segue destinationViewController];
    vc.key = self.algorithm;
}



@end
