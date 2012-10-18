//
//  EPSCMSViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/18/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCMSViewController.h"

@interface EPSCMSViewController ()

@end

@implementation EPSCMSViewController
@synthesize efSegmentedControl;
@synthesize hfClassSegmentedControl;
@synthesize criteriaTableView;
@synthesize risks;

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
    [self.efSegmentedControl setTitle:@">35"forSegmentAtIndex:0];
        [self.efSegmentedControl setTitle:@">30&≤35"forSegmentAtIndex:1];
        [self.efSegmentedControl setTitle:@"≤30"forSegmentAtIndex:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEfSegmentedControl:nil];
    [self setHfClassSegmentedControl:nil];
    [self setCriteriaTableView:nil];
    self.risks = nil;
    [super viewDidUnload];
}
@end
