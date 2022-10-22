//
//  EPSTabBarViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/14/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSTabBarViewController.h"

#import "EP_Mobile-Swift.h"

@interface EPSTabBarViewController ()

@end

@implementation EPSTabBarViewController

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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showInformationView) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInformationView {
    NSArray *references = [NSArray arrayWithObject:[[Reference alloc] init:@"Adler A, Novelli V, Amin AS, et al. An International, Multicentered, Evidence-Based Reappraisal of Genes Reported to Cause Congenital Long QT Syndrome. Circulation. 2020;141(6):418-428. doi:10.1161/CIRCULATIONAHA.119.043132"]];
    [InformationViewController showWithVc:self instructions:NULL key:NULL references:references name:@"LQTS Subtypes"];
}


@end
