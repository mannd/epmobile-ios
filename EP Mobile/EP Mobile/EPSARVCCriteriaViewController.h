//
//  EPSARVCCriteriaViewController.h
//  EP Mobile
//
//  Created by David Mann on 8/3/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSARVCCriteriaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *headers;
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
@property (strong, nonatomic) NSString *criteria;
@end
