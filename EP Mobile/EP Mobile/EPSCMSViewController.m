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

// these magic numbers are in Data.plist
#define CARDIAC_ARREST 0
#define SUS_VT 1
#define FAMILIAL_CONDITION 2
#define ISCHEMIC_CM 3
#define NONISCHEMIC_CM 4
#define LONG_DURATION_CM 5
#define MI 6
#define INDUCIBLE_VT 7
#define QRS_DURATION_LONG 8
#define CARDIOGENIC_SHOCK 9
#define RECENT_CABG 10
#define RECENT_MI 11
#define RECENT_MI_EPS 12
#define REVASCULARIZATION_CANDIDATE 13
#define BAD_PROGNOSIS 14
#define BRAIN_DAMAGE 15
#define ABSOLUTE_EXCLUSION 100
#define POSSIBLE_INDICATION 200

#define DEFAULT_CELL_HEIGHT 60
#define BIG_CELL_HEIGHT 80

@interface EPSCMSViewController ()

@end

@implementation EPSCMSViewController
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
        [self.efSegmentedControl setTitle:@">30&≤35"forSegmentAtIndex:1];
        [self.efSegmentedControl setTitle:@"≤30"forSegmentAtIndex:2];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEfSegmentedControl:nil];
    [self setHfClassSegmentedControl:nil];
    [self setCriteriaTableView:nil];
    self.list = nil;
    self.headers = nil;
    self.checkedItems = nil;
    [super viewDidUnload];
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
            if ([criteria selected]) {
                NSNumber *value = [NSNumber numberWithInt:[criteria points]];
                [self.checkedItems addObject:value];
            }
    }
}

- (BOOL)itemIsChecked:(int)item {
    return [self.checkedItems containsObject:[NSNumber numberWithInt:item]];
}

- (BOOL)absoluteExclusion {
    return ([self itemIsChecked:CARDIOGENIC_SHOCK] || [self itemIsChecked:REVASCULARIZATION_CANDIDATE] || [self itemIsChecked:BAD_PROGNOSIS]);
}



- (IBAction)calculateResult:(id)sender {
    [self calculateCheckedItems];
    int result = -1;
    // according to NCD, brain damage excludes all indications
    if ([self itemIsChecked:BRAIN_DAMAGE])
        result = BRAIN_DAMAGE;
    else if ([self itemIsChecked:CARDIAC_ARREST])
        result = CARDIAC_ARREST;
    else if ([self itemIsChecked:SUS_VT])
        result = SUS_VT;
    else if ([self absoluteExclusion])
        result = ABSOLUTE_EXCLUSION;
    else if ([self itemIsChecked:FAMILIAL_CONDITION])
        result = FAMILIAL_CONDITION;
    else
        result = POSSIBLE_INDICATION;
    NSLog(@"CMS result = %d", result);
    [self showResults:[self getResultMessage:result]];
}

- (void)showResults:(NSString *)message {
    NSString *details = message;
    NSString *title = @"CMS ICD Criteria";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:details delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}

- (NSString *)getResultMessage:(int)result {
    NSString *icdApprovedMessage = @"ICD implantation appears to meet CMS guidelines.";
    NSString *icdNotApprovedMessage = @"ICD implantation does NOT meet CMS guidelines.";
    NSString *crtApprovedMessage = @"\nUse of a CRT-ICD may be indicated.";
    NSString *message = @"";
    if (result == BRAIN_DAMAGE) {
        message = [message stringByAppendingString:icdNotApprovedMessage];
        message = [message stringByAppendingString:@"\nIrreversible brain damage is an absolute exclusion for ICD implantation."];
        return message;
    }
    BOOL efLessThan30 = [self.efSegmentedControl selectedSegmentIndex] == 2;
    BOOL efLessThan35 = efLessThan30 || [self.efSegmentedControl selectedSegmentIndex] == 1;
    BOOL nyhaIIorIII = [self.hfClassSegmentedControl selectedSegmentIndex] == 1 || [self.hfClassSegmentedControl selectedSegmentIndex] == 2;
    BOOL nyhaIV = [self.hfClassSegmentedControl selectedSegmentIndex] == 3;
    BOOL nyhaIIIorIV = nyhaIV || [self.hfClassSegmentedControl selectedSegmentIndex] == 2;
    BOOL crtCriteriaMet = nyhaIIIorIV && [self itemIsChecked:QRS_DURATION_LONG] && efLessThan35;
    // no ef or NHYA class needed for secondary prevention
    if (result == CARDIAC_ARREST || result == SUS_VT) {
        message = [message stringByAppendingString:@"Secondary Prevention\n"];
        message = [message stringByAppendingString:icdApprovedMessage];
        if (crtCriteriaMet)
            message = [message stringByAppendingString:crtApprovedMessage];
        return message;
    }
    message = [message stringByAppendingString:@"Primary Prevention\n"];
    // check absolute exclusions since they apply to all other indications
    if (result == ABSOLUTE_EXCLUSION) {
        message = [message stringByAppendingString:icdNotApprovedMessage];
        message = [message stringByAppendingString:@"\nICD implantation has one or more exclusions"];
        return message;
    }
    if (result == FAMILIAL_CONDITION) {
        message = [message stringByAppendingString:icdApprovedMessage];
        if (crtCriteriaMet)
            message = [message stringByAppendingString:crtApprovedMessage];
        return message;
    }
	// primary prevention except for familial condition needs ef and NYHA
    // class (because NYHA class IV is an exclusion except for CRT)
    // Since no radio buttons in iOS version, don't need to check to see
    // if these are selected, like we do in Android version.
    
    // Now work out possible indications
    BOOL indicated = NO;
    // MADIT II -- note MADIT II explicitly excludes class IV,
    // but Guideline 8 allows class IV if QRS wide
    indicated = efLessThan30 && [self itemIsChecked:MI] && (!nyhaIV || crtCriteriaMet);
	// MADIT
    BOOL maditIndication = NO;
    if (!indicated) {
        indicated = efLessThan35 && [self itemIsChecked:MI] && [self itemIsChecked:INDUCIBLE_VT];
        if (indicated)
            maditIndication = true;
    }
	// SCD-Heft Ischemic CM
    if (!indicated)
        indicated = efLessThan35 && [self itemIsChecked:ISCHEMIC_CM]
        && [self itemIsChecked:MI]
        && (nyhaIIorIII || crtCriteriaMet);
    // SCD-Heft Nonischemic CM
	if (!indicated)
        indicated = efLessThan35 && [self itemIsChecked:NONISCHEMIC_CM]
        && (nyhaIIorIII || crtCriteriaMet)
        && [self itemIsChecked:LONG_DURATION_CM];
    
    if (indicated) {
        if ([self itemIsChecked:RECENT_MI]) {
            message = [message stringByAppendingString:icdNotApprovedMessage];
            message = [message stringByAppendingString:@"\nICD implantation is too soon post MI."];
        } else if (maditIndication && [self itemIsChecked:RECENT_MI_EPS]) {
            message = [message stringByAppendingString:icdNotApprovedMessage];
            message = [message stringByAppendingString:@"\nEPS performed too soon post MI."];
        } else if ([self itemIsChecked:RECENT_CABG]) {
            message = [message stringByAppendingString:icdNotApprovedMessage];
            message = [message stringByAppendingString:@"\nICD implantation is too soon post myocardial revascularization"];
        } else if (crtCriteriaMet && nyhaIV) // CRT-ICD must be used for
            // NYHA IV
            message = [message stringByAppendingString:@"CRT-ICD implantation appears to meet CMS guidelines."];
        else {
            message = [message stringByAppendingString:icdApprovedMessage];
            if (crtCriteriaMet)
                message = [message stringByAppendingString:crtApprovedMessage];
        }
    } else
        message = [message stringByAppendingString:icdNotApprovedMessage];

    
    
    return message;
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
    BOOL selected = [[[self.list objectAtIndex:section] objectAtIndex:row] selected];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this is very tweaky
    if (([indexPath section] == 0 && [indexPath row] == 1) ||
        ([indexPath section] == 1 && [indexPath row] == 0))
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
        [[[self.list objectAtIndex:section] objectAtIndex:row] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[[self.list objectAtIndex:section] objectAtIndex:row] setSelected:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
