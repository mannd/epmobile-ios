//
//  EPSQTcIVCDViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/23/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTcIVCDViewController.h"
#import "EPSQTMethods.h"

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
    
}

- (IBAction)clearButtonPressed:(id)sender {
    self.rateIntervalField.text = nil;
    self.qtField.text = nil;
    self.qrsField.text = nil;
}

- (IBAction)toggleInputType:(id)sender {
    self.qtField.text = nil;
    self.qrsField.text = nil;
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
