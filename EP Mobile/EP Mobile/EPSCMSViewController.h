//
//  EPSCMSViewController.h
//  EP Mobile
//
//  Created by David Mann on 10/18/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSCMSViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISegmentedControl *efSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *hfClassSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *criteriaTableView;
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) NSArray *headers;
@property (strong, nonatomic) NSMutableSet *checkedItems;
@end
