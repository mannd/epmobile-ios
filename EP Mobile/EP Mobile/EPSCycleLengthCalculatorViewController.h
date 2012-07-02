//
//  EPSCycleLengthCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSCycleLengthCalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)calculateButton:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)toggleSwitch:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
