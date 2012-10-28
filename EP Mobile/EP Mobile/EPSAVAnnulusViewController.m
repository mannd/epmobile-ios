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
@synthesize epicardialapImageView;
@synthesize lalapImageView;
@synthesize llapImageView;
@synthesize lpapImageView;
@synthesize lplapImageView;
@synthesize msapImageView;
@synthesize psmaapImageView;
@synthesize pstaapImageView;
@synthesize raapImageView;
@synthesize ralapImageView;
@synthesize rlapImageView;
@synthesize rplapImageView;
@synthesize rpapImageView;
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
        self.epicardialapImageView.hidden = !([self.location1 isEqualToString:SUBEPI] || [self.location2 isEqualToString:SUBEPI]);
        self.lalapImageView.hidden = !([self.location1 isEqualToString:LAL] || [self.location2 isEqualToString:LAL]);
        self.llapImageView.hidden = !([self.location1 isEqualToString:LL] || [self.location2 isEqualToString:LL]);
        self.lpapImageView.hidden = !([self.location1 isEqualToString:LP] || [self.location2 isEqualToString:LP]);
        self.lplapImageView.hidden = !([self.location1 isEqualToString:LPL] || [self.location2 isEqualToString:LPL]);
        self.msapImageView.hidden = !([self.location1 isEqualToString:MSTA] || [self.location2 isEqualToString:MSTA]);
        self.psmaapImageView.hidden = !([self.location1 isEqualToString:PSMA] || [self.location2 isEqualToString:PSMA]);
        self.pstaapImageView.hidden = !([self.location1  isEqualToString:PSTA] || [self.location2 isEqualToString:PSTA]);
        self.raapImageView.hidden = !([self.location1 isEqualToString:RA] || [self.location2 isEqualToString:RA]);
        self.ralapImageView.hidden = !([self.location1 isEqualToString:RAL] || [self.location2 isEqualToString:RAL]);
        self.rlapImageView.hidden = !([self.location1 isEqualToString:RL] || [self.location2 isEqualToString:RL]);
        self.rplapImageView.hidden = !([self.location1 isEqualToString:RPL] || [self.location2 isEqualToString:RPL]);
        self.rpapImageView.hidden = !([self.location1 isEqualToString:RP] || [self.location2 isEqualToString:RP]);
    }

}

- (void)viewDidUnload
{
    [self setMapImageView:nil];
    [self setAsapImageView:nil];
    self.location1 = nil;
    self.location2 = nil;
    [self setMapLocationLabel:nil];
    [self setEpicardialapImageView:nil];
    [self setLalapImageView:nil];
    [self setLalapImageView:nil];
    [self setLlapImageView:nil];
    [self setLpapImageView:nil];
    [self setLplapImageView:nil];
    [self setMsapImageView:nil];
    [self setPsmaapImageView:nil];
    [self setPstaapImageView:nil];
    [self setRaapImageView:nil];
    [self setRalapImageView:nil];
    [self setRlapImageView:nil];
    [self setRplapImageView:nil];
    [self setRpapImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (![self showPathway])
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    else
        return NO;
}

@end
