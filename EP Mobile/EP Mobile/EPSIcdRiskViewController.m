//
//  EPSIcdRiskViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/25/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

#import "EPSIcdRiskViewController.h"

@interface EPSIcdRiskViewController ()

@end

@implementation EPSIcdRiskViewController

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
//    float width = scrollView.bounds.size.width;
//    float height = scrollView.bounds.size.height;
    scrollView.contentSize = CGSizeMake(320, 836);
    //scrollView.minimumZoomScale = 1.0;
    //scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [scrollView viewWithTag:999];
//}


@end
