//
//  EPSCycleLengthCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSCycleLengthCalculatorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *resultUnits;
@property (strong, nonatomic) NSString *resultPrefix;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
- (IBAction)calculateButton:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)toggleSwitch:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
