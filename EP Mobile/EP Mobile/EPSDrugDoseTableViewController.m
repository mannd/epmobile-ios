//
//  EPSDrugDoseTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSDrugDoseTableViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"
#import "EP_Mobile-Swift.h"

#define APIXABAN_ROW 0
#define DABIGATRAN_ROW 1
#define DOFETIDLE_ROW 2
#define EDOXABAN_ROW 3
#define RIVAOXABAN_ROW 4
#define SOTALOL_ROW 5

@interface EPSDrugDoseTableViewController ()

@end

@implementation EPSDrugDoseTableViewController

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DrugName drugName;
    NSInteger row = indexPath.row;
    if (row == APIXABAN_ROW) {
        drugName = DrugNameApixaban;
    }
    else if (row == DABIGATRAN_ROW) {
        drugName = DrugNameDabigatran;
    }
    else if (row == DOFETIDLE_ROW) {
        drugName = DrugNameDofetilide;
    }
    else if (row == EDOXABAN_ROW) {
        drugName = DrugNameEdoxaban;
    }
    else if (row == RIVAOXABAN_ROW) {
        drugName = DrugNameRivaroxaban;
    }
    else if (row == SOTALOL_ROW) {
        drugName = DrugNameSotalol;
    } else {
        return;
    }
    [DrugCalculatorController showWithVc:self drugName: drugName];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSDrugDoseCalculatorViewController *vc = (EPSDrugDoseCalculatorViewController *)[segue destinationViewController]; 
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"DabigatranSegue"])
        vc.drug = @"Dabigatran";
    else if ([segueIdentifier isEqualToString:@"DofetilideSegue"])
        vc.drug = @"Dofetilide";
    else if ([segueIdentifier isEqualToString:@"RivaroxabanSegue"])
        vc.drug = @"Rivaroxaban";
    else if ([segueIdentifier isEqualToString:@"SotalolSegue"])
        vc.drug = @"Sotalol";
    else if ([segueIdentifier isEqualToString:@"ApixabanSegue"])
        vc.drug = @"Apixaban";
    else if ([segueIdentifier isEqualToString:@"EdoxabanSegue"])
        vc.drug = @"Edoxaban";
}

@end
