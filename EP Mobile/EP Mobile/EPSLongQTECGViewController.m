//
//  EPSLongQTECGViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLongQTECGViewController.h"

@interface EPSLongQTECGViewController ()

@end

@implementation EPSLongQTECGViewController

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
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews objectAtIndex:0];
}



@end
