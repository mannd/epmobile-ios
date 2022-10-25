//
//  EPSVTViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSVTViewController.h"
#import "EPSSimpleAlgorithmViewController.h"
#import "EP_Mobile-Swift.h"

@interface EPSVTViewController ()

@end

@implementation EPSVTViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"EpiEndoVTSegue"]) {
        InformationViewController *infoVC = (InformationViewController *)[segue destinationViewController];
        infoVC.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Berruezo A, Mont L, Nava S, Chueca E, Bartholomay E, Brugada J. Electrocardiographic Recognition of the Epicardial Origin of Ventricular Tachycardias. Circulation. 2004;109(15):1842-1847. doi:10.1161/01.CIR.0000125525.04081.4B"]];
        infoVC.name = @"Epi vs Endo VT";
    }
    EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
    if ([segueIdentifier isEqualToString:@"OutflowVTSegue"])
        vc.algorithmName = @"OutflowVT";
    else if ([segueIdentifier isEqualToString:@"AnnularVTSegue"])
        vc.algorithmName = @"AnnularVT";
}


@end
