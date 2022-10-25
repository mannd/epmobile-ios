//
//  EPSCMSViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/18/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCMSViewController.h"
#import "EPSRiskFactor.h"
#import "EPSLogging.h"
#import "EPSSharedMethods.h"
#import "EPSCMSViewModel.h"
#import "EP_Mobile-Swift.h"

// these magic numbers are in Data.plist
#define SUS_VT 0
#define CARDIAC_ARREST 1
#define MI 2
#define ISCHEMIC_CM 3
#define NONISCHEMIC_CM 4
#define FAMILIAL_CONDITION 5
#define ICD_ERI 6
#define TRANSPLANT_CANDIDATE 7
#define RECENT_CABG 8
#define RECENT_MI 9
#define REVASCULARIZATION_CANDIDATE 10
#define CARDIOGENIC_SHOCK 11
#define BAD_PROGNOSIS 12
#define BRAIN_DAMAGE 13
#define UNCONTROLLED_SVT 14

#define DEFAULT_CELL_HEIGHT 80
#define BIG_CELL_HEIGHT 120

@interface EPSCMSViewController ()

@end

@implementation EPSCMSViewController
{
    EPSCMSViewModel *viewModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewTitle = @"CMS ICD Criteria";
    [self initView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.checkedItems = [[NSMutableSet alloc] init];
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *cmsDictionary = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"CMS"]];
    NSArray *headerArray = [[NSArray alloc] initWithArray:[cmsDictionary objectForKey:@"SectionHeaders"]] ;
    self.headers = headerArray;

    NSArray *cmsCriteriaArray = [[NSArray alloc] initWithArray:[cmsDictionary objectForKey:@"Sections"]];
    NSMutableArray *risks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [cmsCriteriaArray count]; ++i) {
        // init each section
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[cmsCriteriaArray objectAtIndex:i] count]; ++j) {
            EPSRiskFactor *risk = [[EPSRiskFactor alloc] initWith:[[[cmsCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:0] withValue:[[[[cmsCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:1] integerValue]];


            [tmpArray addObject:risk];
        }
        [risks addObject:tmpArray];
    }

    self.list = risks;

    [self.efSegmentedControl setTitle:@">35"forSegmentAtIndex:0];
    [self.efSegmentedControl setTitle:@">30 & ≤35"forSegmentAtIndex:1];
    [self.efSegmentedControl setTitle:@"≤30"forSegmentAtIndex:2];
    [self.efSegmentedControl setSelectedSegmentIndex:0];
    [self.hfClassSegmentedControl setSelectedSegmentIndex:0];
}

- (void)showNotes {
    NSString *instructions = @"Select patient characteristics and then select Calculate to show whether the patient is likely to meet CMS guidelines for Medicare reimbursement. Note the CMS National Coverage Determination (NCD) is quite detailed and you should be very familiar with it before making a decision as to whether a particular patient is covered. This module is only intended as a guide to the NCD and is not definitive. The module has been updated to the latest 2018 CMS guidelines.";
    NSString *key = @"AF = atrial fibrillation.\nCA = cardiac arrest.\nCABG = coronary artery bypass grafting.\nCM = cardiomyopathy.\nCMS = Centers for Medicare and Medicaid Services.\nEF = ejection fraction.\nEPS = electrophysiology study.\nHCM = hypertrophic cardiomyopathy.\nICD = implantable cardioverter defibrillator.\nOMT = optimal medical therapy.\nMI = myocardial infarction.\nNYHA = New York Heart Association.\nPCI = percutaneous coronary intervention.\nSVT = supraventricular tachycardia.\nVT = ventricular tachycardia/tachyarrhythmia.\nVF = ventricular fibrillation.";
    Reference *reference = [[Reference alloc] init:@"CMS: Decision Memo for Implantable Cardioverter Defibrillators (CAG-00157R4) Feb 15, 2018.\nhttps://www.cms.gov/medicare-coverage-database/details/nca-decision-memo.aspx?NCAId=288"];
    NSMutableArray *references = [[NSMutableArray alloc] init];
    if (reference != NULL) {
        [references addObject:reference];
    }
    [InformationViewPresenter showWithVc:self instructions:instructions key:key references:references name:self.viewTitle];
}

- (void)calculateCheckedItems {
    [self.checkedItems removeAllObjects];
    for (id object in self.list) {
        for (id criteria in object)
            if ([criteria isSelected]) {
                NSNumber *value = [NSNumber numberWithInteger:[criteria points]];
                [self.checkedItems addObject:value];
            }
    }
}

- (BOOL)itemIsChecked:(int)item {
    return [self.checkedItems containsObject:[NSNumber numberWithInt:item]];
}

- (IBAction)cancel:(id)sender {
    [self clear];
}

- (IBAction)calculate:(id)sender {
    [self calculate];
}

- (void)calculate {
    [self createViewModel];
    NSString *message = viewModel.getMessage;
    [self showResults:message];
}

- (void)clear {
    [self initView];
    [self.criteriaTableView reloadData];
}

- (void)showResults:(NSString *)message {
    NSString *title = @"CMS ICD Criteria";
    [EPSSharedMethods showDialogWithTitle:title andMessage:message inView:self];
}


- (void)createViewModel {
    EF ef;
    switch ([self.efSegmentedControl selectedSegmentIndex]) {
        case 0:
            ef = EFMoreThan35;
            break;
        case 1:
            ef = EFFrom30To35;
            break;
        case 2:
            ef = EFLessThan30;
            break;
        default:
            ef = EFNA;
    }
    Nyha nyha;
    switch ([self.hfClassSegmentedControl selectedSegmentIndex]) {
        case 0:
            nyha = NyhaI;
            break;
        case 1:
            nyha = NyhaII;
            break;
        case 2:
            nyha = NyhaIII;
            break;
        case 3:
            nyha = NyhaIV;
            break;
        default:
            nyha = NyhaNA;
    }
    [self calculateCheckedItems];
    viewModel = [[EPSCMSViewModel alloc] initWithSusVT:[self itemIsChecked:SUS_VT]
                                                          cardiacArrest:[self itemIsChecked:CARDIAC_ARREST]
                                                                priorMI:[self itemIsChecked:MI]
                                                                    icm:[self itemIsChecked:ISCHEMIC_CM]
                                                                   nicm:[self itemIsChecked:NONISCHEMIC_CM]
                                                      highRiskCondition:[self itemIsChecked:FAMILIAL_CONDITION]
                                                               icdAtEri:[self itemIsChecked:ICD_ERI]
                                                         transplantList:[self itemIsChecked:TRANSPLANT_CANDIDATE]
                                                                     ef:ef nyha:nyha
                                                      cabgWithin3Months:[self itemIsChecked:RECENT_CABG]
                                                         miWithin40Days:[self itemIsChecked:RECENT_MI]
                                                     candidateForRevasc:[self itemIsChecked:REVASCULARIZATION_CANDIDATE]
                                                       cardiogenicShock:[self itemIsChecked:CARDIOGENIC_SHOCK]
                                                      nonCardiacDisease:[self itemIsChecked:BAD_PROGNOSIS]
                                                            brainDamage:[self itemIsChecked:BRAIN_DAMAGE]
                                                        uncontrolledSvt:[self itemIsChecked:UNCONTROLLED_SVT]];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.list objectAtIndex:section ] count];
  }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CMSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSString *text = [[[self.list objectAtIndex:section] objectAtIndex:row ] name];
    cell.textLabel.text = text;
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    BOOL selected = [[[self.list objectAtIndex:section] objectAtIndex:row] isSelected];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this is very tweaky
    if ([indexPath section] == 0 ||
        ([indexPath section] == 1 && [indexPath row] == 3))
        return BIG_CELL_HEIGHT;
    else
        return DEFAULT_CELL_HEIGHT;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[[self.list objectAtIndex:section] objectAtIndex:row] setIsSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[[self.list objectAtIndex:section] objectAtIndex:row] setIsSelected:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
