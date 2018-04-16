//
//  EPSLQTSDetailsTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/16/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLQTSDetailsTableViewController.h"

@interface EPSLQTSDetailsTableViewController ()

@end

@implementation EPSLQTSDetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5)
        return 100;
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
