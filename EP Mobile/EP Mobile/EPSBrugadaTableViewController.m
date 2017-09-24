//
//  EPSBrugadaTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/23/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSBrugadaTableViewController.h"
#import "EPSLinkViewController.h"


@interface EPSBrugadaTableViewController ()

@end

@implementation EPSBrugadaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EPSLinkViewController *lc = (EPSLinkViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"BrugadaDiagnosisSegue"]) {
        lc.webPage = @"brugadadiagnosis";
        lc.linkTitle = @"Brugada Diagnosis";
    }

}


@end
