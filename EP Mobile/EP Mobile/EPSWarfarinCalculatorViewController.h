//
//  EPSWarfarinCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/20/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDoseChange : NSObject
{
    enum Direction { DECREASE, INCREASE };
}
@property (assign, nonatomic) NSInteger lowEnd;
@property (assign, nonatomic) NSInteger highEnd;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) enum Direction direction;

@end

@interface EPSWarfarinCalculatorViewController : UIViewController
    <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *weeklyDoseField;
@property (strong, nonatomic) IBOutlet UITextField *inrField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tabletSizeSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *targetSegmentedControl;
@property (strong, nonatomic) IBOutlet UIPickerView *tabletSizePickerView;

@property (strong, nonatomic) EPSDoseChange *doseChange;
@property (strong, nonatomic) NSString *defaultWarfarinTabletSize;
@property (strong, nonatomic) NSString *defaultINR;
@property (strong, nonatomic) NSArray *tabletSizeData;

- (IBAction)toggleTargetRange:(id)sender;
- (IBAction)calculateButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

- (BOOL)weeklyDoseIsSane:(float)dose forTabletSize:(float)size;

@end

