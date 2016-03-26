//
//  EPSQTcIVCDResultsViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/26/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTcIVCDResultsViewController.h"

#define DETAILS @"Details"

@interface EPSQTcIVCDResultsViewController ()

@end

@implementation EPSQTcIVCDResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // We are using TextFields for results: use delegate
    // method to prevent editing.
    self.qtResult.delegate = self;
    self.jtResult.delegate = self;
    self.qtcResult.delegate = self;
    self.jtcResult.delegate = self;
    self.qtmResult.delegate = self;
    self.qtmcResult.delegate = self;
    self.qtrrqrsResult.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.qtResult.text = [NSString stringWithFormat:@"QT = %ld msec", (long)self.qt];
    self.jtResult.text = [NSString stringWithFormat:@"JT = %ld msec", (long)self.jt];
    self.qtcResult.text = [NSString stringWithFormat:@"QTc (Bazett) = %ld msec", (long)self.qtc];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)qtInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"QT = %ld msec.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined.", (long)self.qt];
    [self showInfo:info withTitle:DETAILS];
}

- (IBAction)jtInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"JT = %ld msec.\n\nFormula: JT = QT - QRS\n\nNormal values: Not defined.", (long)self.jt];
    [self showInfo:info withTitle:DETAILS];
}
- (IBAction)qtcInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"QTc = %ld msec.\n\nFormula: QTc = QT in sec / SQRT(RR in sec)\n\nNormal values: Male xxx Female xxx.", (long)self.qtc];
    [self showInfo:info withTitle:DETAILS];

}

- (IBAction)jtcInfoButton:(id)sender {
}

- (IBAction)qtmInfoButton:(id)sender {
}

- (IBAction)qtmcInfoButton:(id)sender {
}

- (IBAction)qtrrqrsInfoButton:(id)sender {
}

- (void)showInfo:(NSString *)info withTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
@end
