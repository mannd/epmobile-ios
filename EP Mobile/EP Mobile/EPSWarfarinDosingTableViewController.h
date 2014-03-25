//
//  EPSDosingTableViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSWarfarinDosingTableViewController : UIViewController
- (IBAction)doneButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highChangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunDose1;
@property (weak, nonatomic) IBOutlet UILabel *sunDose2;
@property (weak, nonatomic) IBOutlet UILabel *monDose1;
@property (weak, nonatomic) IBOutlet UILabel *monDose2;
@property (weak, nonatomic) IBOutlet UILabel *tueDose1;
@property (weak, nonatomic) IBOutlet UILabel *tueDose2;
@property (weak, nonatomic) IBOutlet UILabel *wedDose1;
@property (weak, nonatomic) IBOutlet UILabel *wedDose2;
@property (weak, nonatomic) IBOutlet UILabel *thuDose1;
@property (weak, nonatomic) IBOutlet UILabel *thuDose2;
@property (weak, nonatomic) IBOutlet UILabel *friDose1;
@property (weak, nonatomic) IBOutlet UILabel *friDose2;
@property (weak, nonatomic) IBOutlet UILabel *satDose1;
@property (weak, nonatomic) IBOutlet UILabel *satDose2;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;
@property (weak, nonatomic) IBOutlet UILabel *totalWeeklyLowDose;
@property (weak, nonatomic) IBOutlet UILabel *totalWeeklyHighDose;

@property (assign, nonatomic) float tabletSize;
@property (assign, nonatomic) NSInteger lowEnd;
@property (assign, nonatomic) NSInteger highEnd;
@property (assign, nonatomic) BOOL increase;
@property (assign, nonatomic) float weeklyDose;

@end
