//
//  EPSQTcIVCDViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/23/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSQTcIVCDViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *rateIntervalField;
@property (strong, nonatomic) IBOutlet UITextField *qtField;
@property (strong, nonatomic) IBOutlet UITextField *qrsField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *intervalRateSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (strong, nonatomic) IBOutlet UISwitch *lbbbSwitch;

@property BOOL defaultInputTypeIsInterval;

- (IBAction)calculateButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)toggleInputType:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
