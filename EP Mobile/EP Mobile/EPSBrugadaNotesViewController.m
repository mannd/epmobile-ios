//
//  EPSBrugadaNotesViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaNotesViewController.h"

@interface EPSBrugadaNotesViewController ()

@end

@implementation EPSBrugadaNotesViewController
@synthesize notesLabel;
@synthesize key;
@synthesize titleBar;

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
    if ([self.key isEqualToString:@"OutflowVT"])
        self.titleBar.topItem.title = @"Outflow Tract VT";
    else if ([self.key isEqualToString:@"AnnularVT"])
        self.titleBar.topItem.title = @"Mitral Annular VT";
    [notesLabel setText:@"Type 1: Coved ST elevation with \u2265 2 mm J-point elevation and gradually descending ST segment followed by negative T wave.  Considered diagnostic of Brugada syndrome if occurs spontaneously or induced by drug challenge.\n\nType 2: Saddle back pattern with \u2265 2 mm J-point elevation and \u2265 1 mm ST elevation with a positive or biphasic T wave.  Occasionally seen in healthy subjects.\n\nType 3: Saddle back pattern with < 2 mm J point elevation and < 1 mm ST elevation with positive T wave.  Not uncommon in healthy subjects."];
}

- (void)viewDidUnload
{
    self.key = nil;
    [self setNotesLabel:nil];
    [self setTitleBar:nil];
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
