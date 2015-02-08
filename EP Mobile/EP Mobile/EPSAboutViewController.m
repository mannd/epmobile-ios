//
//  EPSAboutViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/29/12.
//  Copyright (c) 2012, 2013, 2104 EP Studios. All rights reserved.
//

#import "EPSAboutViewController.h"

#define VERSION @"3.6"

@interface EPSAboutViewController ()

@end

@implementation EPSAboutViewController

@synthesize aboutTextView;

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
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    //self.titleBar. = editButton;
    self.aboutTextView.text = [[NSString alloc] initWithFormat:@"\n\nEP Mobile for Apple iOS\nTools for Cardiac Electrophysiology\nVersion %@\n\nEmail\nmannd@epstudiossoftware.com\nWeb\nwww.epstudiossoftware.com\nSource\ngithub.com/mannd/epmobile-ios\n\nCopyright © 2012, 2013, 2014, 2015\nEP Studios, Inc.", VERSION];
}

- (void)viewDidUnload
{

    [self setAboutTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
