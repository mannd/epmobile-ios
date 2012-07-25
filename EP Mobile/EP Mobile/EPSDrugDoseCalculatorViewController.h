//
//  EPSDrugDoseCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDrugDoseCalculatorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *weightUnitsSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *creatinineField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *drug;


- (IBAction)toggleWeightUnits:(id)sender;
- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)toggleSex:(id)sender;

- (int)creatinineClearanceForAge:(double)age isMale:(BOOL)isMale forWeightInKgs:(double)weight forCreatinine:(double)creatinine;
- (double)lbsToKgs:(double)weight;
@end
