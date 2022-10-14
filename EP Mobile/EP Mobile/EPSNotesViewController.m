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
#import "EPSLogging.h"

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
    EPSLog(@"self key = %@", self.key);
    id <EPSNotesProtocol> notes = nil;
    if ([self.key isEqualToString:@"OutflowVT"])
        notes = [[EPSOutFlowTractVTNotes alloc] init];
    else if ([self.key isEqualToString:@"AnnularVT"])
        notes = [[EPSAnnularVTNotes alloc] init];
    else if ([self.key isEqualToString:@"BrugadaECG"])
        notes = [[EPSBrugadaNotes alloc] init];
    [self.notesTextView setText:[notes noteText]];
    self.titleBar.topItem.title = [notes titleText];
    self.headerLabel.text = [notes labelText];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.notesTextView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
