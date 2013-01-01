//
//  EPSDrugDoseTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSDrugDoseTableViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"


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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
}

@end
