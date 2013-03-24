//
//  EPSDateCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDateCalculatorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *daysSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *numberOfDaysTextField;
@property (strong, nonatomic) IBOutlet UISwitch *subtractDaysSwitch;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)changeNumberOfDays:(id)sender;

@end
