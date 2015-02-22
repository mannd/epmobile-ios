//
//  EPSMainTableViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSMainTableViewController : UITableViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@property (strong, nonatomic) IBOutlet UITableViewCell *drugCalculatorCell;


@end
