//
//  EPSWPWTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWPWTableViewController.h"
#import "EPSSimpleAlgorithmViewController.h"
#import "EP_Mobile-Swift.h"

#define EASY_WPW_ROW 3
#define SMART_WPW_ROW 6

@interface EPSWPWTableViewController ()

@end

@implementation EPSWPWTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == EASY_WPW_ROW) {
        [NewDecisionTreeViewController showWithVc:self algorithm:@"arruda-algorithm"];
    }
    if (row == SMART_WPW_ROW) {
        [DecisionTreeViewController showWithVc:self];
    }
}


//// TODO: Temporariy inhibit segue to UIKit version of Modified Arruda algorithm
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//
//    if ([identifier isEqualToString:@"ModifiedArrudaSegue"]) {
//        return NO;
//    }
//    return YES;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"ArrudaSegue"]) {
        vc.algorithmName = @"ArrudaWPW";
        vc.instructions = @"Note this algorithm uses polarity of initial 20 msec of the delta wave (positive +, negative -, or isoelectric ±)";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Arruda MS, McClelland JH, Wang X, et al. Development and validation of an ECG algorithm for identifying accessory pathway ablation site in Wolff-Parkinson-White syndrome. J Cardiovasc Electrophysiol. 1998;9(1):2-12. doi:10.1111/j.1540-8167.1998.tb00861.x"]];
    }
    else if ([segueIdentifier isEqualToString:@"MilsteinSegue"]) {
        vc.algorithmName = @"MilsteinWPW";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Milstein S, Sharma AD, Guiraudon GM, Klein GJ. An algorithm for the electrocardiographic localization of accessory pathways in the Wolff-Parkinson-White syndrome. Pacing Clin Electrophysiol. 1987;10(3 Pt 1):555-563. doi:10.1111/j.1540-8159.1987.tb04520.x"]];
    }
    else if ([segueIdentifier isEqualToString:@"ModifiedArrudaSegue"]) {
        vc.algorithmName = @"ModifiedArrudaWPW";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Szilágyi SM, Szilágyi L, Görög LK, et al. An Enhanced Accessory Pathway Localization Method for Efficient Treatment of Wolff-Parkinson-White Syndrome. In: Ruiz-Shulcloper J, Kropatsch WG, eds. Progress in Pattern Recognition, Image Analysis and Applications. Vol 5197. Lecture Notes in Computer Science. Springer Berlin Heidelberg; 2008:269-276. doi:10.1007/978-3-540-85920-8_33"]];
    }
    else if ([segueIdentifier isEqualToString:@"DavilaSegue"]) {
        vc.algorithmName = @"DavilaWPW";
        vc.instructions = @"Note that this algorithm uses QRS polarity, not delta wave polarity!";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"d’Avila A, Brugada J, Skeberis V, Andries E, Sosa E, Brugada P. A fast and reliable algorithm to localize accessory pathways based on the polarity of the QRS complex on the surface ECG during sinus rhythm. Pacing Clin Electrophysiol. 1995;18(9 Pt 1):1615-1627. doi:10.1111/j.1540-8159.1995.tb06983.x"]];
    }
}

@end
