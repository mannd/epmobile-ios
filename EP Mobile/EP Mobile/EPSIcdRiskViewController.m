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
    float width = scrollView.bounds.size.width;
    float height = scrollView.bounds.size.height;
    scrollView.contentSize = CGSizeMake(width, height);
    //scrollView.minimumZoomScale = 1.0;
    //scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *array = [[NSArray alloc] initWithObjects:@"Initial implant", @"Gen change for ERI", @"Gen change for infection", @"Gen change for device relocation", @"Gen change for upgrade" , @"gen change for malfunction", @"gen change other reason", nil];
    self.procedureTypeData = array;


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

#pragma mark - Picker Data Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.procedureTypeData count];
}


# pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.procedureTypeData objectAtIndex:row];
}


@end
