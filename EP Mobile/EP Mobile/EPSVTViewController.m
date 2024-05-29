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
    if ([segueIdentifier isEqualToString:@"OutflowVTSegue"]) {
        vc.algorithmName = @"OutflowVT";
        vc.instructions = @"Ventricular tachycardia and premature ventricular complexes can arise from either the right or left ventricular outflow tract (RVOT or LVOT).  Outflow tract VT has a vertical axis and a left bundle branch block pattern in the precordial leads. The earlier the precordial transition lead, the more likely the VT is from the LVOT.  If the precordial transition is in lead V3 it is not possible to use this algorithm to determine from which ventricle the VT arises using this algorithm.  Instead use the V2 Transition Ratio module";
       vc.references = [NSArray arrayWithObjects:[Reference referenceFromCitation:@"Joshi S, Wilber DJ. Ablation of idiopathic right ventricular outflow tract tachycardia: current perspectives. J Cardiovasc Electrophysiol. 2005;16 Suppl 1:S52-58. doi:10.1111/j.1540-8167.2005.50163.x"], [Reference referenceFromCitation:@"Srivathsan K, Lester SJ, Appleton CP, Scott LR, Munger TM. Ventricular Tachycardia in the Absence of Structural Heart Disease. Indian Pacing Electrophysiol J. 2005;5(2):106-121. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1502082/"], [Reference referenceFromCitation:@"Tanner H, Hindricks G, Schirdewahn P, et al. Outflow tract tachycardia with R/S transition in lead V3. Journal of the American College of Cardiology. 2005;45(3):418-423. doi:10.1016/j.jacc.2004.10.037"], nil];
    }
    else if ([segueIdentifier isEqualToString:@"AnnularVTSegue"]) {
        vc.algorithmName = @"AnnularVT";
        vc.instructions = @"Use this module to predict the location of idiopathic mitral annular ventricular tachycardia or premature ventricular complexes based on the ECG.  Note that this module does not deal with mitral isthmus VT in the setting of inferior infarction (see Wilber DJ, Kopp DE, Glascock DO DN, Kinder CA, Kall JG. Catheter Ablation of the Mitral Isthmus for Ventricular Tachycardia Associated With Inferior Infarction. Circulation. 1995;92(12):3481-3489. https://doi.org/10.1161/01.CIR.92.12.3481 )";
        vc.references = [NSArray arrayWithObjects:[Reference referenceFromCitation:@"Wilber DJ, Kopp DE, Glascock DO DN, Kinder CA, Kall JG. Catheter Ablation of the Mitral Isthmus for Ventricular Tachycardia Associated With Inferior Infarction. Circulation. 1995;92(12):3481-3489. doi:10.1161/01.CIR.92.12.3481"], [Reference referenceFromCitation:@"Tada H, Ito S, Naito S, et al. Idiopathic ventricular arrhythmia arising from the mitral annulus: a distinct subgroup of idiopathic ventricular arrhythmias. J Am Coll Cardiol. 2005;45(6):877-886. doi:10.1016/j.jacc.2004.12.025"], nil];
    }
    else if ([segueIdentifier isEqualToString:@"V2TransitionSegue"]) {
        vc.algorithmName = @"V2TransitionVT";
        vc.instructions = @"This algorithm is used to determine the origin of outflow tract ventricular tachycardia or premature ventricular complexes when the QRS transition of the ventricular complexes is in lead V3.  These complexes can arise from either the right or left ventricular outflow tract (RVOT or LVOT). \n\nThis algorithm requires measuring the R and S waves in sinus rhythm and in VT.  You can then calculate the V2 transition ratio yourself or have the app calculate it. \n\nTo calculate the V2 transition ratio manually, measure the R wave in lead V2 in a sinus beat, and divide by the total amplitude of the complex in sinus rhythm, i.e. (R/R+S), which is the percentage R wave in sinus rhythm. Do the same calculation with a ventricular complex, i.e. (R/R+S), which is the percentage R wave in VT.  Then divide the percentage R wave in VT by the percentage R wave in sinus rhythm to get the V2 transition ratio. \n\nNote that the app EP Calipers is useful to make these measurements.";
        vc.references = [NSArray arrayWithObjects:[Reference referenceFromCitation:@"Betensky BP, Park RE, Marchlinski FE, et al. The V(2) transition ratio: a new electrocardiographic criterion for distinguishing left from right ventricular outflow tract tachycardia origin. J Am Coll Cardiol. 2011;57(22):2255-2262. doi:10.1016/j.jacc.2011.01.035"], nil];
    }

}


@end
