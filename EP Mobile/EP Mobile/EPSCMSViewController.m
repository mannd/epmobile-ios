//
//  EPSCMSViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/18/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCMSViewController.h"
#import "EPSCMSNotes.h"
#import "EPSNotesViewController.h"
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
@synthesize efSegmentedControl;
@synthesize hfClassSegmentedControl;
@synthesize criteriaTableView;
@synthesize list;
@synthesize headers;
@synthesize checkedItems;

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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//
//    UIButtonConfiguration *configuration = [UIButton roundedButtonConfiguration];
//    configuration.title = @"Calculate";
//    UIAction *calculateAction = [UIAction actionWithHandler:^(UIAction* action){
//        [self calculate];
//    }];
//    UIButton *calculateButton = [UIButton buttonWithConfiguration:configuration primaryAction:calculateAction];
//    UIBarButtonItem *calculateBarButton = [[UIBarButtonItem alloc] initWithCustomView:calculateButton];
//
//    configuration.title = @"   Clear   ";
//    UIAction *clearAction = [UIAction actionWithHandler:^(UIAction* action){
//        [self clear];
//    }];
//    UIButton *clearButton = [UIButton buttonWithConfiguration:configuration primaryAction:clearAction];
//    UIBarButtonItem *clearBarButton = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
//    self.toolbarItems = [ NSArray arrayWithObjects: spacer, calculateBarButton, spacer, clearBarButton, spacer, nil ];
//
//    [self.navigationController setToolbarHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"CMSNotesSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"CMSNotesSegue"]) {
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"CMSNotes";
    }
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

- (IBAction)calculateResult:(id)sender {
    [self createViewModel];
    NSString *message = viewModel.getMessage;
    [self showResults:message];
}

- (void)calculate {
    [self createViewModel];
    NSString *message = viewModel.getMessage;
    [self showResults:message];
}

- (void)clear {
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
    return [headers objectAtIndex:section];
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
