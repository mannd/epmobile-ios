//
//  EPSQTcCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/16/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSQTcCalculatorViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *formulaPicker;
@property (strong, nonatomic) NSArray *formulaData;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UITextField *qtField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *intervalRateSegmentedControl;

@property (strong, nonatomic) NSString *defaultQTcFormula;
@property float maxQTc;
@property BOOL defaultInputTypeIsInterval;

- (IBAction)calculateButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)toggleInputType:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

- (NSInteger)qtcFromQtInMsec:(NSInteger)qt AndIntervalInMsec:(NSInteger)interval UsingFormula:(NSInteger)formula;

- (void)refreshDefaults;

@end
