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
    [InformationViewPresenter showWithVc:self instructions:NULL key:NULL references:self.references name:self.name];
}

@end
