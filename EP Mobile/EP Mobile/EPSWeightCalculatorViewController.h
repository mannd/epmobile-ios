//
//  EPSWeightCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 6/29/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSWeightCalculatorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *weightUnitsSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *heightUnitsSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *heightTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) NSString *defaultWeightUnit;
@property (strong, nonatomic) NSString *defaultHeightUnit;

- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)copyIbw:(id)sender;
- (IBAction)copyAbw:(id)sender;
- (IBAction)toggleWeightUnits:(id)sender;
- (IBAction)toggleHeightUnits:(id)sender;
- (IBAction)toggleSex:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;



@end
