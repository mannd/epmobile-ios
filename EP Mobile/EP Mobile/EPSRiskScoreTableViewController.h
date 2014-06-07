//
//  EPSRiskScoreTableViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSRiskScoreTableViewController : UITableViewController
    <UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *risks;
@property (strong, nonatomic) NSString *scoreType;


@end
