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

@interface EPSNotesViewController ()

@end

@implementation EPSNotesViewController
@synthesize notesLabel;
@synthesize key;
@synthesize titleBar;
@synthesize headerLabel;

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
    [self.notesLabel setText:[notes noteText]];
    self.titleBar.topItem.title = [notes titleText];
    self.headerLabel.text = [notes labelText];
}

- (void)viewDidUnload
{
    self.key = nil;
    [self setNotesLabel:nil];
    [self setTitleBar:nil];
    [self setHeaderLabel:nil];
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
