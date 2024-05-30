//
//  EPSAboutViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/29/12.
//  Copyright (c) 2012, 2013, 2104 EP Studios. All rights reserved.
//

#import "EPSAboutViewController.h"

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
    self.aboutTextView.text = [[NSString alloc] initWithFormat:@"\n\nEP Mobile for Apple iOS\nTools for Cardiac Electrophysiology\nVersion %@\n\nEmail\nmannd@epstudiossoftware.com\nWeb\nwww.epstudiossoftware.com\nSource\ngithub.com/mannd/epmobile-ios\n\nCopyright © 2012 - 2024\nEP Studios, Inc.", [self getVersion]];
}

- (NSString *)getVersion {
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = dictionary[@"CFBundleShortVersionString"];
#ifdef DEBUG // Get build number, if you want it. Cleaner to leave out of release version.
    NSString *build = dictionary[@"CFBundleVersion"];
    // the version+build format is recommended by https://semver.org
    NSString *versionBuild = [NSString stringWithFormat:@"%@+%@", version, build];
    return versionBuild;
#else
    return version;
#endif
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
