//
//  EPSAVAnnulusViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/7/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSAVAnnulusViewController.h"

@interface EPSAVAnnulusViewController ()

@end

@implementation EPSAVAnnulusViewController
@synthesize mapImageView;

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
    // all these labels will have to be tweaked with GIMP
//    UIImage *testView = [UIImage imageNamed:@"asap.png"];
//    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:testView];
//
//    [self.mapImageView addSubview:overlayImageView];
    
}

- (void)viewDidUnload
{
    [self setMapImageView:nil];
    [self setAsapImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
