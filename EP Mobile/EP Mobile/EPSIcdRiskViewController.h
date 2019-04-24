//
//  EPSIcdRiskViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/25/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSIcdRiskViewController : UIViewController
    <UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,
    UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *nyhaClassSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reasonForAdmissionSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *abnormalConductionSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sodiumSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *bunSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *hgbSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *otherRisksTableView;
@property (strong, nonatomic) IBOutlet UIPickerView *procedureTypePickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *icdTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *referenceLabel;

@property (strong, nonatomic) NSArray* procedureTypeData;
@property (strong, nonatomic) NSMutableArray *risks;

- (IBAction)openReferenceLink:(id)sender;


@end
