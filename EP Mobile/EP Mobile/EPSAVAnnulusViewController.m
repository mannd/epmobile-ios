//
//  EPSAVAnnulusViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/7/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSAVAnnulusViewController.h"
#import "EPSAccessoryPathwayLocations.h"

@interface EPSAVAnnulusViewController ()

@end

@implementation EPSAVAnnulusViewController
@synthesize mapImageView;
@synthesize mapLocationLabel;
@synthesize asapImageView;
@synthesize showPathway;
@synthesize message;
@synthesize location1;
@synthesize location2;

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
    self.mapLocationLabel.hidden = ![self showPathway];
    if ([self showPathway]) {
        [self setTitle:@"AP Location"];
        [self.mapLocationLabel setText:self.message];
        self.asapImageView.hidden = !([self.location1 isEqualToString:AS] || [self.location2 isEqualToString:AS]);
    }
//    UIImage *testView = [UIImage imageNamed:@"asap.png"];
//    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:testView];
//
//    [self.mapImageView addSubview:overlayImageView];
    
}

- (void)viewDidUnload
{
    [self setMapImageView:nil];
    [self setAsapImageView:nil];
    self.location1 = nil;
    self.location2 = nil;
    [self setMapLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
