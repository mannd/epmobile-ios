//
//  EPSBrugadaECGViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaECGViewController.h"
#import "EPSNotesViewController.h"
#import "EP_Mobile-Swift.h"

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
//    self.automaticallyAdjustsScrollViewInsets = NO;
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
        [InformationViewController
         showWithVc:self
         instructions:NULL
         key:NULL
         references:[NSArray arrayWithObject:[[Reference alloc] init:@"Wilde AAM, Antzelevitch C, Borggrefe M, et al. Proposed Diagnostic Criteria for the Brugada Syndrome. Circulation. 2002;106(19):2514-2519.\ndoi:/10.1161/01.CIR.0000034169.45752.4A"]]
         name:@"Brugada ECG"
         optionalSectionTitle:@"ST-T Abnormalities in V1-V3"
         optionalSectionText:@"Type 1: Coved ST elevation with \u2265 2 mm J-point elevation and gradually descending ST segment followed by negative T wave.  Considered diagnostic of Brugada syndrome if occurs spontaneously or induced by drug challenge.\n\nType 2: Saddle back pattern with \u2265 2 mm J-point elevation and \u2265 1 mm ST elevation with a positive or biphasic T wave.  Occasionally seen in healthy subjects.\n\nType 3: Saddle back pattern with < 2 mm J point elevation and < 1 mm ST elevation with positive T wave.  Not uncommon in healthy subjects."];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews objectAtIndex:0];
}

@end
