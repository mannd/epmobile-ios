//
//  EPSHcmScd2014ViewController.m
//  EP Mobile
//
//  Created by David Mann on 5/30/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSHcmScd2014ViewController.h"

@interface EPSHcmScd2014ViewController ()

@end

@implementation EPSHcmScd2014ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"HCM SCD 2014";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.ageTextField resignFirstResponder];
    [self.thicknessTextField resignFirstResponder];
    [self.sizeTextField resignFirstResponder];
    [self.gradientTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)calculate:(id)sender {
}

- (IBAction)clear:(id)sender {
    self.ageTextField.text = nil;
    self.thicknessTextField.text = nil;
    self.sizeTextField.text = nil;
    self.gradientTextField.text = nil;
    [self.familyHxSwitch setOn:NO animated:YES];
    [self.nsvtSwitch setOn:NO animated:YES];
    [self.syncopeSwitch setOn:NO animated:YES];
}


@end
