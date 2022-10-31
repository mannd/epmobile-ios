//
//  EPSWCTTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWCTTableViewController.h"
#import "EPSSimpleAlgorithmViewController.h"
#import "EPSTabBarViewController.h"
#import "EP_Mobile-Swift.h"

@interface EPSWCTTableViewController ()

@end

@implementation EPSWCTTableViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"BrugadaAlgorithmSegue"]) {
        EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
        vc.algorithmName = @"BrugadaWCT";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Brugada P, Brugada J, Mont L, Smeets J, Andries EW. A new approach to the differential diagnosis of a regular tachycardia with a wide QRS complex. Circulation. 1991;83(5):1649-1659. doi:10.1161/01.cir.83.5.1649"]];
    }
    else if ([segueIdentifier isEqualToString:@"VTMorphologySegue"]) {
        EPSTabBarViewController *vc = (EPSTabBarViewController *)[segue destinationViewController];
        vc.name = @"Morphology Criteria";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Wellens HJ, Bär FW, Lie KI. The value of the electrocardiogram in the differential diagnosis of a tachycardia with a widened QRS complex. Am J Med. 1978;64(1):27-33. doi:10.1016/0002-9343(78)90176-6"]];

    }
    else if ([segueIdentifier isEqualToString:@"RWavePeakTimeSegue"]) {
        InformationViewController *vc = (InformationViewController *)[segue destinationViewController];
        vc.name = @"R Wave Peak Time";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Pava LF, Perafán P, Badiel M, et al. R-wave peak time at DII: a new criterion for differentiating between wide complex QRS tachycardias. Heart Rhythm. 2010;7(7):922-926. doi:10.1016/j.hrthm.2010.03.001"]];
    }
    else if ([segueIdentifier isEqualToString:@"VereckeiAlgorithmSegue"]) {
        EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
        vc.algorithmName = @"VereckeiWCT";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Vereckei A, Duray G, Szénási G, Altemose GT, Miller JM. New algorithm using only lead aVR for differential diagnosis of wide QRS complex tachycardia. Heart Rhythm. 2008;5(1):89-98. doi:10.1016/j.hrthm.2007.09.020"]];
    }
}

@end
