//
//  EPSBrugadaMorphologyViewController.h
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSBrugadaMorphologyViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
