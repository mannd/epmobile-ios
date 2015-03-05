//
//  EPSDrugReferenceTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 2/24/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSDrugReferenceTableViewController.h"
#import "EPSLinkViewController.h"
#import "EPSLogging.h"

@interface EPSDrugReferenceTableViewController ()

@end

@implementation EPSDrugReferenceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self clearSavedCreatinineClearanceData];

}

- (void)viewDidAppear:(BOOL)animated {
    // clear old creatinine clearance data on entry into this view
    [self.navigationController setToolbarHidden:YES];
}


- (void) clearSavedCreatinineClearanceData {
    EPSLog(@"Clearing saved CrCl data");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:0.0 forKey:@"CC_age"];
    [userDefaults setBool:YES forKey:@"CC_is_male"];
    [userDefaults setDouble:0.0 forKey:@"CC_weight_in_kgs"];
    [userDefaults setDouble:0.0
                     forKey:@"CC_creatinine"];
    [userDefaults setDouble:0.0 forKey:@"CC_creatinine_clearance"];
    // CC units?
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EPSLinkViewController *lc = (EPSLinkViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];

    if ([segueIdentifier isEqualToString:@"apixabanReferenceSegue"]) {
        lc.webPage = @"apixaban";
        lc.drugTitle = @"Apixaban";
    }
    else if ([segueIdentifier isEqualToString:@"dabigatranReferenceSegue"])
        lc.webPage = @"http://www.crediblemeds.org";
    else if ([segueIdentifier isEqualToString:@"dofetilideReferenceSegue"])
        lc.webPage = @"parahisianpacinginstructions";
    else if ([segueIdentifier isEqualToString:@"edoxabanReferenceSegue"]) {
        lc.webPage = @"edoxaban";
        lc.drugTitle = @"Edoxaban";
    }
    else if ([segueIdentifier isEqualToString:@"rivaroxabanReferenceSegue"])
        lc.webPage = @"rvapexvsbasepacing";
    else if ([segueIdentifier isEqualToString:@"sotalolReferenceSegue"])
        lc.webPage = @"rvapexvsbasepacing";
    lc.showToolbar = YES;
    
    
    
    

}


@end
