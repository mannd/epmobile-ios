//
//  EPSIcdRiskViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/25/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSIcdRiskViewController : UIViewController
    <UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UISegmentedControl *procedureTypeSegmentedControl;
@property (strong, nonatomic) NSArray* procedureTypeData;

@end
