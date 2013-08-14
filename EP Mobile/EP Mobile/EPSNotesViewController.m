//
//  EPSBrugadaNotesViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSNotesViewController.h"
#import "EPSBrugadaNotes.h"
#import "EPSOutFlowTractVTNotes.h"
#import "EPSAnnularVTNotes.h"
#import "EPSWarfarinNotes.h"
#import "EPSCMSNotes.h"
#import "EPSDateCalculatorNotes.h"
#import "EPSEntrainmentNotes.h"
#import "EPSAtrialTachNotes.h"
#import "EPSWeightCalculatorNotes.h"


@interface EPSNotesViewController ()

@end

@implementation EPSNotesViewController
@synthesize key;
@synthesize titleBar;
@synthesize headerLabel;
@synthesize notesTextView;

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
    NSLog(@"self key = %@", self.key);
    id <EPSNotesProtocol> notes = nil;
    if ([self.key isEqualToString:@"OutflowVT"])
        notes = [[EPSOutFlowTractVTNotes alloc] init];
    else if ([self.key isEqualToString:@"AnnularVT"])
        notes = [[EPSAnnularVTNotes alloc] init];
    else if ([self.key isEqualToString:@"BrugadaECG"])
        notes = [[EPSBrugadaNotes alloc] init];
    else if ([self.key isEqualToString:@"WarfarinNotes"])
        notes = [[EPSWarfarinNotes alloc] init];
    else if ([self.key isEqualToString:@"CMSNotes"])
        notes = [[EPSCMSNotes alloc] init];
    else if ([self.key isEqualToString:@"DateCalculatorNotes"])
        notes = [[EPSDateCalculatorNotes alloc] init];
    else if ([self.key isEqualToString:@"EntrainmentNotes"])
        notes = [[EPSEntrainmentNotes alloc] init];
    else if ([self.key isEqualToString:@"AtrialTachNotes"])
        notes = [[EPSAtrialTachNotes alloc] init];
    else if ([self.key isEqualToString:@"WeightCalculatorNotes"])
        notes = [[EPSWeightCalculatorNotes alloc] init];
    [self.notesTextView setText:[notes noteText]];
    self.titleBar.topItem.title = [notes titleText];
    self.headerLabel.text = [notes labelText];
}

- (void)viewDidUnload
{
    self.key = nil;
    [self setTitleBar:nil];
    [self setHeaderLabel:nil];
    [self setNotesTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

// for iOS 6
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
