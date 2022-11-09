//
//  EPSSQTViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/31/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSQTViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *qtcSegmentedControl;

@property (weak, nonatomic) IBOutlet UITableView *riskTableView;
@property (strong, nonatomic) NSMutableArray *risks;
@end
