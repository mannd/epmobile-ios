//
//  EPSQTcIVCDViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/23/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTcIVCDViewController.h"
#import "EPSQTMethods.h"
#import "EPSQTcIVCDResultsViewController.h"


#define INTERVAL_OR_RATE_KEY @"intervalorrate"
#define RATE_INDEX 0
#define INTERVAL_INDEX 1

@interface EPSQTcIVCDViewController ()

@end

@implementation EPSQTcIVCDViewController
{
    BOOL inputIsRate;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    inputIsRate = YES;
    self.lbbbSwitch.on = NO;
    // male sex defaults
    self.sexSegmentedControl.selectedSegmentIndex = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self refreshDefaults];
    if (self.defaultInputTypeIsInterval) {
        [self setInputType:INTERVAL_INDEX];
        [self.intervalRateSegmentedControl setSelectedSegmentIndex:INTERVAL_INDEX];
    }
    else {
        [self setInputType:RATE_INDEX];
        [self.intervalRateSegmentedControl setSelectedSegmentIndex:RATE_INDEX];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.rateIntervalField resignFirstResponder];
    [self.qtField resignFirstResponder];
    [self.qrsField resignFirstResponder];
}

- (IBAction)calculateButtonPressed:(id)sender {
    NSLog(@"Calculate!");
    double rateInterval = [self.rateIntervalField.text doubleValue];
    double qt = [self.qtField.text doubleValue];
    double qrs = [self.qrsField.text doubleValue];
    if (rateInterval <= 0 || qt <= 0 || qrs <= 0) {
        [self showError];
        return;
    }
    double interval;
    double rate;
    if (inputIsRate) {
        interval = 60000.0 / rateInterval;
        rate = rateInterval;
    }
    else {
        interval = rateInterval;
        rate = 60000.0 / rateInterval;
    }
    // qtc uses Bazett in this module
    self.qt = (NSInteger)round(qt);
    self.qtc = [EPSQTMethods qtcFromQtInMsec:qt AndIntervalInMsec:interval UsingFormula:kBazett];
    self.jt = [EPSQTMethods jtFromQTInMsec:qt andQRSInMsec:qrs];
    self.jtc = [EPSQTMethods jtCorrectedFromQTInMsec:qt andIntervalInMsec:interval withQRS:qrs];
    if (self.lbbbSwitch.on) {
        self.qtm = [EPSQTMethods qtCorrectedForLBBBFromQTInMSec:qt andQRSInMsec:qrs];
        self.qtmc = [EPSQTMethods qtcFromQtInMsec:self.qtm AndIntervalInMsec:interval UsingFormula:kBazett];
    }
    self.qtrrqrs = [EPSQTMethods qtCorrectedForIVCDAndSexFromQTInMsec:qt AndHR:rate AndQRS:qrs IsMale:[self isMale]];
    [self performSegueWithIdentifier:@"QTcIVCDResultsSegue" sender:nil];

}

- (IBAction)clearButtonPressed:(id)sender {
    self.rateIntervalField.text = nil;
    self.qtField.text = nil;
    self.qrsField.text = nil;
}

- (IBAction)toggleInputType:(id)sender {
    self.rateIntervalField.text = nil;
    [self setInputType:[sender selectedSegmentIndex]];
    
}

- (void)refreshDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultIntervalOrRate = [defaults objectForKey:INTERVAL_OR_RATE_KEY];
    self.defaultInputTypeIsInterval = ([defaultIntervalOrRate isEqualToString:@"interval"]);
}

- (void)setInputType:(NSInteger)index {
    if ((inputIsRate = index == RATE_INDEX))
        self.rateIntervalField.placeholder = @"Heart Rate (bpm)";
    else
        self.rateIntervalField.placeholder = @"RR Interval (msec)";
}

- (BOOL)isMale {
    return self.sexSegmentedControl.selectedSegmentIndex == 0;
}

- (void)showError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Error" message:@"One or more values are incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EPSQTcIVCDResultsViewController *vc = (EPSQTcIVCDResultsViewController *)[segue destinationViewController];
    vc.isLBBB = self.lbbbSwitch.on;
    vc.qt = self.qt;
    vc.qtc = self.qtc;
    vc.jt = self.jt;
    vc.jtc = self.jtc;
    vc.qtm = self.qtm;
    vc.qtmc = self.qtmc;
    vc.qtrrqrs = self.qtrrqrs;
}


@end
