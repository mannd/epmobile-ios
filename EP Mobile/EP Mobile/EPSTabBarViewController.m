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
    UIImage *infoImage = [UIImage systemImageNamed:@"info.circle"];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:infoImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showInformationView)];
    infoButton.tintColor = [UIColor labelColor];
    infoButton.accessibilityLabel = @"Information";
    self.navigationItem.rightBarButtonItem = infoButton;
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
