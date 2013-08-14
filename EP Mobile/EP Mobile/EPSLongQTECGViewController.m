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
    UIScrollView *scrollView = (UIScrollView *)self.view;
    float width = scrollView.bounds.size.width;
    float height = scrollView.bounds.size.height;
    scrollView.contentSize = CGSizeMake(width, height);
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
