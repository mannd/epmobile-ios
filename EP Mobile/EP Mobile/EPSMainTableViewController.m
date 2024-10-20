//
//  EPSMainTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012, 2013, 2014 EP Studios. All rights reserved.
//

#import "EPSMainTableViewController.h"
#import "EPSLinkViewController.h"
#import "EPSDrugDoseTableViewController.h"
#import "EPSARVCCriteriaViewController.h"
#import "EPSAtriaBleedRiskScore.h"
#import "EPSAtriaStrokeRiskScore.h"
#import "EPSChadsRiskScore.h"
#import "EPSChadsVascRiskScore.h"
#import "EPSHasBledRiskScore.h"
#import "EPSHemorrhagesRiskScore.h"
#import "EPSHcmRiskScore.h"
#import "EPSIcdMortalityRiskScore.h"
#import "EPSTamponadeRiskScore.h"
#import "EPSErsRiskScore.h"
#import "EPSOrbitRiskScore.h"
#import "EPSQTProlongationRisk.h"
#import "EPSSameTtrRiskScore.h"
#import "EP_Mobile-Swift.h"

// Sigh!
// TODO: Switch back to NO!!!! for release version.
// Apple won't allow drug calculators in apps.
#define ALLOW_DRUG_CALCULATORS NO

// NB: These defines are all hard-coded, and any changes, additions, or deletions
// to the main table view controller entries will require changing these values.
// Also remember row 2 is invisible (the banned drug calculators).

// Calculators section
#define CALCULATOR_SECTION 0
#define CRCL_CALCULATOR_ROW 0
#define DATE_CALCULATOR_ROW 1
#define DRUG_CALCULATORS_ROW 2
#define INTERVAL_RATE_ROW 3
#define GFR_CALCULATOR_ROW 4
#define QTC_CALCULATOR_ROW 5
#define QTC_IVCD_CALCULATOR_ROW 6
#define WARFARIN_CLINIC_ROW 7
#define WEIGHT_CALCULATOR_ROW 8
// Diagnosis section
#define DIAGNOSIS_SECTION 1
#define TAMPONADE_ROW 4
#define EARLY_REPOL_ROW 5
// References and tools section
#define REFERENCES_TOOLS_SECTION 2
#define ENTRAINMENT_CALCULATOR_ROW 2
// Risk scores section
#define RISK_SCORES_SECTION 3
#define APPLE_ROW 0
#define ARVC_RISK_ROW 1
#define ATRIA_BLEED_ROW 2
#define ATRIA_STROKE_ROW 3
#define CHADS_ROW 4
#define CHADS_VASC_ROW 5
#define FRAILTY_ROW 6
#define HAS_BLED_ROW 7
#define HEMORRHAGES_ROW 8
#define HCM_SCD_ROW 9
#define ICD_IMPLANTATION_RISK_ROW 10
#define ICD_MORTALITY_RISK_ROW 11
#define ORBIT_RISK_ROW 12
#define QT_PROLONGATION_RISK_ROW 13
#define SAME_TTR_ROW 14
#define SYNCOPE_ROW 15

@interface EPSMainTableViewController ()

@end

@implementation EPSMainTableViewController
{
    BOOL allowDrugCalculators;
}
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

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    
    allowDrugCalculators = ALLOW_DRUG_CALCULATORS;
    
    [self.drugCalculatorCell setHidden:!allowDrugCalculators];
}

- (void)showAbout {
    [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];

    // Hide Drug calculator row, per Apple request.
    if (section == CALCULATOR_SECTION && row == DRUG_CALCULATORS_ROW && !allowDrugCalculators)
        return 0; //set the hidden cell's height to 0
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CALCULATOR_SECTION) { // Calculators
        if (indexPath.row == CRCL_CALCULATOR_ROW) {
            [DrugCalculatorController showWithVc:self drugName:DrugNameCrCl];
        }
        if (indexPath.row == INTERVAL_RATE_ROW) {
            [IntervalRateCalculatorController showWithVc:self];
        }
        if (indexPath.row == GFR_CALCULATOR_ROW) {
            [DrugCalculatorController showWithVc:self drugName:DrugNameGfr];
        }
        if (indexPath.row == DATE_CALCULATOR_ROW) {
            [DateCalculatorController showWithVc:self];
        }
        if (indexPath.row == QTC_CALCULATOR_ROW) {
            [QTcCalculatorController showWithVc:self];
        }
        if (indexPath.row == QTC_IVCD_CALCULATOR_ROW) {
            [QTcIvcdCalculatorController showWithVc:self];
        }
        if (indexPath.row == WARFARIN_CLINIC_ROW) {
            [WarfarinClinicController showWithVc:self];
        }
        if (indexPath.row == WEIGHT_CALCULATOR_ROW) {
            [WeightCalculatorCalculatorController showWithVc:self];
        }
    } else if (indexPath.section == DIAGNOSIS_SECTION) { // Diagnosis
        if (indexPath.row == TAMPONADE_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSTamponadeRiskScore alloc] init]];
        }
        if (indexPath.row == EARLY_REPOL_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSErsRiskScore alloc] init]];
        }
    } else if (indexPath.section == REFERENCES_TOOLS_SECTION) { // Reference & Tools
        if (indexPath.row == ENTRAINMENT_CALCULATOR_ROW) {
            [EntrainmentCalculatorViewController showWithVc:self];
        }
    } else if (indexPath.section == RISK_SCORES_SECTION) { // Risk scores
        if (indexPath.row == APPLE_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[AppleScore alloc] init]];
        }
        if (indexPath.row == ATRIA_BLEED_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSAtriaBleedRiskScore alloc] init]];
        }
        if (indexPath.row == ATRIA_STROKE_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSAtriaStrokeRiskScore alloc] init]];
        }
        if (indexPath.row == CHADS_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSChadsRiskScore alloc] init]];
        }
        if (indexPath.row == CHADS_VASC_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSChadsVascRiskScore alloc] init]];
        }
        if (indexPath.row == FRAILTY_ROW) {
            [FrailtyViewController showWithVc:self];
        }
        if (indexPath.row == HAS_BLED_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSHasBledRiskScore alloc] init]];
        }
        if (indexPath.row == HEMORRHAGES_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSHemorrhagesRiskScore alloc] init]];
        }
        if (indexPath.row == HCM_SCD_ROW) {

            //[RiskScoreViewController showWithVc:self riskScore:[[EPSHcmRiskScore alloc] init]];
        }
//        if (indexPath.row == HCM_2014_ROW) {
//            [HcmViewController showWithVc:self];
//        }
        if (indexPath.row == ICD_MORTALITY_RISK_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSIcdMortalityRiskScore alloc] init]];
        }
        if (indexPath.row == ORBIT_RISK_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSOrbitRiskScore alloc] init]];
        }
        if (indexPath.row == QT_PROLONGATION_RISK_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[[EPSQTProlongationRisk alloc] init]];
        }
        if (indexPath.row == SAME_TTR_ROW) {
            [RiskScoreViewController showWithVc:self riskScore:[EPSSameTtrRiskScore new]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    
    EPSLinkViewController *vc = (EPSLinkViewController *)[segue destinationViewController];

    if ([segueIdentifier isEqualToString:@"ParaHisSegue"]) {
        vc.webPage = @"parahisianpacinginstructions";
        vc.linkTitle = @"Para-Hisian Pacing";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Hirao K, Otomo K, Wang X, et al. Para-Hisian pacing. A new method for differentiating retrograde conduction over an accessory AV pathway from conduction over the AV node. Circulation. 1996;94(5):1027-1035. doi:10.1161/01.cir.94.5.1027"]];
    }
    else if ([segueIdentifier isEqualToString:@"RVPaceSegue"]) {
        vc.webPage = @"rvapexvsbasepacing";
        vc.linkTitle = @"RV Apex vs Base Pacing";
        vc.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Martínez-Alday JD, Almendral J, Arenal A, et al. Identification of concealed posteroseptal Kent pathways by comparison of ventriculoatrial intervals from apical and posterobasal right ventricular sites. Circulation. 1994;89(3):1060-1067. doi:10.1161/01.cir.89.3.1060"]];
    }
    else if ([segueIdentifier isEqualToString:@"RvhSegue"]) {
        vc.webPage = @"rvh";
        vc.linkTitle = @"RVH Criteria";
        vc.references = [NSArray arrayWithObjects:[Reference referenceFromCitation:@"Lewis T. Observations upon ventricular hypertrophy with special reference to preponderance of one or the other chamber. Heart. 1914;5:367-402." ], [[Reference alloc] init:@"Myers GB, Klein HA, Stofer BE. The electrocardiographic diagnosis of right ventricular hypertrophy. Am Heart J. 1948;35(1):1-40. doi:10.1016/0002-8703(48)90182-3"], [[Reference alloc] init: @"Sokolow M, Lyon TP. The ventricular complex in left ventricular hypertrophy as obtained by unipolar precordial and limb leads. Am Heart J. 1949;37(2):161-186. doi:10.1016/0002-8703(49)90562-1"], [[Reference alloc] init:@"Butler PM, Leggett SI, Howe CM, Freye CJ, Hindman NB, Wagner GS. Identification of electrocardiographic criteria for diagnosis of right ventricular hypertrophy due to mitral stenosis. Am J Cardiol. 1986;57(8):639-643. doi:10.1016/0002-9149(86)90850-7"], [[Reference alloc] init:@"Hancock EW, Deal BJ, Mirvis DM, Okin P, Kligfield P, Gettes LS. AHA/ACCF/HRS Recommendations for the Standardization and Interpretation of the Electrocardiogram. Journal of the American College of Cardiology. 2009;53(11):992-1002. doi:10.1016/j.jacc.2008.12.015"], nil];
    }
    else if ([segueIdentifier isEqualToString:@"LbbbSegue"]) {
        vc.webPage = @"lbbb";
        vc.linkTitle = @"LBBB Criteria";
        vc.references = [NSArray arrayWithObject:[[Reference alloc] init:@"Strauss DG, Selvester RH, Wagner GS. Defining Left Bundle Branch Block in the Era of Cardiac Resynchronization Therapy. American Journal of Cardiology. 2011;107(6):927-934.\ndoi:10.1016/j.amjcard.2010.11.010"]];
    }
  
    EPSARVCCriteriaViewController *arvcVc = (EPSARVCCriteriaViewController *)[segue destinationViewController];
    if ([segueIdentifier isEqualToString:@"ARVC2010Segue"])
        arvcVc.criteria = @"ARVC2010";
    else if ([segueIdentifier isEqualToString:@"ARVC1994Segue"])
        arvcVc.criteria = @"ARVC1994";

    InformationTableViewController *infoTableVC = (InformationTableViewController *)[segue destinationViewController];
    if ([segueIdentifier isEqualToString:@"NormalEPValuesSegue"]) {
        infoTableVC.references = [NSArray arrayWithObject:[Reference referenceFromCitation:@"Josephson ME. Clinical Cardiac Electrophysiology: Techniques and Interpretations. 4th edition. Lippincott Williams & Wilkins; 2008. https://www.amazon.com/Clinical-Cardiac-Electrophysiology-Techniques-Interpretations/dp/0781777399"]];
        infoTableVC.name = @"Normal EP Values";

    }
}


@end
