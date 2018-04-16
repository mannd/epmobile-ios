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
    self.automaticallyAdjustsScrollViewInsets = YES;
}

// See https://www.natashatherobot.com/ios-autolayout-scrollview/ for details
// of how to center view in scrollview properly (note comments also).
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"Layout subviews called");
    CGRect scrollViewBounds = self.scrollView.bounds;
    CGRect imageViewBounds = self.imageView.bounds;

    UIEdgeInsets scrollViewInsets = UIEdgeInsetsZero;
    scrollViewInsets.top = scrollViewBounds.size.height/2.0;
    scrollViewInsets.top -= imageViewBounds.size.height/2.0;

    scrollViewInsets.bottom = scrollViewBounds.size.height/2.0;
    scrollViewInsets.bottom -= imageViewBounds.size.height/2.0;
    scrollViewInsets.bottom += 1;
    
    self.scrollView.contentInset = scrollViewInsets;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews objectAtIndex:0];
}



@end
