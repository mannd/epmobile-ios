//
//  EPSDrugDoseCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDrugDoseCalculatorViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *drugPicker;
@property (strong, nonatomic) NSArray *drugPickerData;

@end
