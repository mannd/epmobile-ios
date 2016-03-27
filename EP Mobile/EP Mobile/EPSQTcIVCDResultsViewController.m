//
//  EPSQTcIVCDResultsViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/26/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTcIVCDResultsViewController.h"

#define DETAILS @"Details"
#define NO_QTM @"QTm only defined for LBBB"
#define NO_QTMC @"QTmc only defined for LBBB"
#define QTM_REFERENCE @"Bogossian H et al. New formula for evaluation of the QT interval in patients with left bundle branch block. Heart Rhythm 2004;11:2273-2277."
#define QTRRQRS_FORMULA @"QTrr,qrs = QT - 155 x (60/HR - 1) - 0.93 x (QRS - 139) + k, k = -22 ms for men and -34 ms for women"
#define QTRRQRS_REFERENCE @"Rautaharju P et al. Assessment of prolonged QT and JT intervals in ventricular conduction defects.  Amer J Cardio 2003;93:1017-1021."
#define QTC_REFERENCE @"Rautaharju P et al. Circulation. 2009;119:e241-e250."

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
    self.qtcResult.text = [NSString stringWithFormat:@"QTc = %ld msec", (long)self.qtc];
    self.jtcResult.text = [NSString stringWithFormat:@"JTc = %ld msec", (long)self.jtc];
    self.qtmResult.text = self.isLBBB ? [NSString stringWithFormat:@"QTm = %ld msec", (long)self.qtm] : NO_QTM;
    self.qtmcResult.text = self.isLBBB ? [NSString stringWithFormat:@"QTmc = %ld msec", (long)self.qtmc] : NO_QTMC;
    self.qtrrqrsResult.text = [NSString stringWithFormat:@"QTrr,qrs = %ld msec", (long)self.qtrrqrs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qtInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"QT = %ld msec.\n\nUse: The QT varies with heart rate, QRS and sex, and so is usually not a good measure of repolarization independent of these other factors.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined.", (long)self.qt];
    [self showInfo:info withTitle:@"Uncorrected QT"];
}

- (IBAction)jtInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"JT = %ld msec.\n\nUse: The JT interval corrects for QRS duration, but does not correct for heart rate.\n\nFormula: JT = QT - QRS\n\nNormal values: Not defined.", (long)self.jt];
    [self showInfo:info withTitle:@"Uncorrected JT"];
}
- (IBAction)qtcInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"QTc = %ld msec.\n\nUse: The QTc corrects for heart rate, in this case using the Bazett formula, but does not correct for increased QRS duration.  \n\nFormula: QTc[sec] = QT[sec] / SQRT(RR[sec])\n\nNormal values (without IVCD) per AHA/ACC/HRS guidelines (%@): Male < 450 msec, Female < 460 msec and > 390 msec (both sexes).", (long)self.qtc, QTC_REFERENCE];
    [self showInfo:info withTitle:@"Corrected QT (QTc)\nBazett Formula"];
}

- (IBAction)jtcInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"JTc = %ld msec.\n\nUse: JTc corrects for heart rate and QRS duration, however normal values are not well established.\n\nFormula: JTc = QTc(Bazett) - QRS", (long)self.jtc];
    [self showInfo:info withTitle:@"Corrected JT (JTc)\nBazett Formula"];
}

- (IBAction)qtmInfoButton:(id)sender {
    NSString *info = self.isLBBB ? [NSString stringWithFormat:@"QTm = %ld msec.\n\nUse: Attempts to correct for the prolongation of the QT interval attributable to QRS prolongation in LBBB.\n\nFormula: QTm = QTb - 0.485 * QRSb\n\nNormal values: Not defined.\n\nReference: %@", (long)self.qt, QTM_REFERENCE] : NO_QTM;
    // link is http://www.heartrhythmjournal.com/article/S1547-5271(14)00915-1/abstract
    [self showInfo:info withTitle:@"Modified QT (QTm) in LBBB"];
}

- (IBAction)qtmcInfoButton:(id)sender {
    NSString *info = self.isLBBB ? [NSString stringWithFormat:@"QTmc = %ld msec.\n\nUse: Takes the QTm and corrects for heart rate, in this case using the Bazett formula.\n\nFormula: QTmc = QTm corrected for rate using Bazett formula\n\nNormal values: Presumably the same as QTc.\n\nReference: %@", (long)self.qtmc, QTM_REFERENCE] : NO_QTMC;
    [self showInfo:info withTitle:@"Corrected Modified QT in LBBB (QTmc)\nBazett Formula "];
}

- (IBAction)qtrrqrsInfoButton:(id)sender {
    NSString *info = [NSString stringWithFormat:@"QTrr,qrs = %ld msec.\n\nUse: Corrects QT for rate, QRS duration and sex.\n\nFormula: %@\n\nNormal values: 2%% and 5%% normal limits of 460 and 450 msec.\n\nReference: %@", (long)self.qtrrqrs, QTRRQRS_FORMULA, QTRRQRS_REFERENCE];
    [self showInfo:info withTitle:@"QT Corrected For Rate,\nQRS, and Sex (QTrr,qrs)"];
    // link is http://www.ajconline.org/article/S0002-9149(04)00025-6/abstract
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
