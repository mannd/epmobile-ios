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
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Notes" style:UIBarButtonItemStyleBordered target:self action:@selector(showNotes)];
//    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
