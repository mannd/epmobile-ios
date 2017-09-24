//
//  EPSDrugDoseCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDrugDoseCalculatorViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *weightUnitsSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *creatinineUnitsSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *creatinineField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *drug;
@property (strong, nonatomic) NSString *defaultWeightUnit;
@property (strong, nonatomic) NSString *defaultCreatinineUnit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)toggleWeightUnits:(id)sender;
- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)toggleSex:(id)sender;
- (IBAction)toggleCrUnits:(id)sender;

- (int)creatinineClearanceForAge:(double)age isMale:(BOOL)isMale forWeightInKgs:(double)weight forCreatinine:(double)creatinine usingMicroMolUnits:(BOOL)usingMicroMolUnits;
- (double)lbsToKgs:(double)weight;
- (double)creatinineFromMicroMolUnits:(double)creatinine;

@end
