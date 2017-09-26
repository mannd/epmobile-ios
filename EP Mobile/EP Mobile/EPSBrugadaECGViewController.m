//
//  EPSBrugadaECGViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaECGViewController.h"
#import "EPSNotesViewController.h"

@interface EPSBrugadaECGViewController ()

@end

@implementation EPSBrugadaECGViewController

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
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];

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

// See https://www.natashatherobot.com/ios-autolayout-scrollview/ for details
// of how to center view in scrollview properly (note comments also).
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"Brugada Layout subviews called");
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = @"BrugadaECG";
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"BrugadaNotesSegue" sender:nil];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews objectAtIndex:0];
}

@end
