//
//  EPSQTViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/31/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSQTViewController.h"
#import "EPSRiskFactor.h"
#import "EPSSharedMethods.h"
#import "EP_Mobile-Swift.h"

// defines for SQTS indexes
#define SQTS_SHORT_JT 0
#define SQTS_ARREST 1
#define SQTS_VT 2
#define SQTS_SYNCOPE 3
#define SQTS_AFB 4
#define SQTS_FH_SQTS 5
#define SQTS_FH_SCD 6
#define SQTS_SIDS 7
#define SQTS_GENOTYPE 8
#define SQTS_MUTATION 9

#define SQTS_TITLE @"SQTS Diagnosis"

@interface EPSQTViewController ()

@end

@implementation EPSQTViewController
@synthesize qtcSegmentedControl;
@synthesize riskTableView;

@synthesize risks;


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
	// Do any additional setup after loading the view.
    [self.qtcSegmentedControl setTitle:@"\u2265 370" forSegmentAtIndex:0];
    [self.qtcSegmentedControl setTitle:@"< 370" forSegmentAtIndex:1];
    [self.qtcSegmentedControl setTitle:@"< 350" forSegmentAtIndex:2];
    [self.qtcSegmentedControl setTitle:@"< 330" forSegmentAtIndex:3];
       
    [self initCriteria];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    [self setTitle:SQTS_TITLE];
}

- (void)initCriteria {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"< 120 msec" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sudden cardiac arrest" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Polymorphic VT or VF" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained syncope" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Atrial fibrillation" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"1\u00B0 or 2\u00B0 relative with SQTS" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"1\u00B0 or 2\u00B0 relative with SCD" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sudden Infant Death Syndrome" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Genotype positive" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Mutation in culprit gene" withValue:1]];

    self.risks = array;
}

- (IBAction)calculate:(id)sender {
    [self calculateScore];
}

- (IBAction)clear:(id)sender {
    [self.qtcSegmentedControl setSelectedSegmentIndex:0];
    [self initCriteria];
    [self.riskTableView reloadData];
}


- (void)calculateScore {
    int score = 0;
    // ECG criteria
    // one of the short QT intervals must be selected to get other points
    if (self.qtcSegmentedControl.selectedSegmentIndex == 0 && ![[self.risks objectAtIndex:SQTS_SHORT_JT] isSelected]) {
        [self displayResult:score];
        return;
    }
    if (self.qtcSegmentedControl.selectedSegmentIndex == 1) // QTc < 370
        ++score;
    else if (self.qtcSegmentedControl.selectedSegmentIndex == 2) // QTc < 350
        score += 2;
    else if (self.qtcSegmentedControl.selectedSegmentIndex ==3) // QTc < 330
        score += 3;
    // short JT very specific for SQTS
    if ([[self.risks objectAtIndex:SQTS_SHORT_JT] isSelected ])
        ++score;
    // Clinical history points can only be received for one of next 3 selections
    if ([[self.risks objectAtIndex:SQTS_ARREST] isSelected] ||[[self.risks objectAtIndex:SQTS_VT] isSelected])
        score += 2;
    else if ([[self.risks objectAtIndex:SQTS_SYNCOPE] isSelected])
        ++score;
    if ([[self.risks objectAtIndex:SQTS_AFB] isSelected])
        ++score;
    // Family history
    // points can only be received once in this section
    if ([[self.risks objectAtIndex:SQTS_FH_SQTS] isSelected])
        score += 2;
    else if ([[self.risks objectAtIndex:SQTS_FH_SCD] isSelected] ||
             [[self.risks objectAtIndex:SQTS_SIDS] isSelected])
        ++score;
    // Genotype
    if ([[self.risks objectAtIndex:SQTS_GENOTYPE] isSelected])
        score += 2;
    if ([[self.risks objectAtIndex:SQTS_MUTATION] isSelected])
        ++score;
    
    [self displayResult:score];
}

- (void)displayResult:(int)score {
    NSString *message = [[NSString alloc] initWithFormat:@"Score = %i\n", score];
	if (score >= 4)
        message = [message stringByAppendingString:@"High probability"];
    else if (score == 3)
        message = [message stringByAppendingString:@"Intermediate probability"];
    else if (score <= 2)
        message = [message stringByAppendingString:@"Low probability"];
    message = [message stringByAppendingString:@" of Short QT Syndrome"];
    [EPSSharedMethods showDialogWithTitle:@"Risk Score" andMessage:message inView:self];
}

- (void)showNotes {
    [InformationViewController
     showWithVc:self
     instructions:@"Electrocardiogram must be recorded in the absence of modifiers known to shorten the QT.  Jpoint-Tpeak interval must be measured in the precordial lead with the greatest amplitude T-wave.  Clinical history: events must occur in the absence of an identifiable etiology, including structural heart disease.  Note that at least one ECG manifestation must be present in order to get additional points."
     key:NULL
     references:[NSArray arrayWithObject:[Reference referenceFromCitation:@"Gollob MH, Redpath CJ, Roberts JD. The short QT syndrome: proposed diagnostic criteria. J Am Coll Cardiol. 2011;57(7):802-812. doi:10.1016/j.jacc.2010.09.048"]]
     name:SQTS_TITLE];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return  1;
    else if (section == 1)
        return  4;
    else if (section == 2) 
        return 3;
    else {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QTCell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    int offset = [self calculateOffset:indexPath.section];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    //NSString *details = [[self.risks objectAtIndex:indexPath.row ] details];
    cell.textLabel.text = risk;
    //cell.detailTextLabel.text = details;
    if ([[self.risks objectAtIndex:(indexPath.row + offset)] isSelected] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (int)calculateOffset:(NSInteger)section {
    int offset = 0;
    if (section == 1)
        offset = 1;
    else if (section == 2)
        offset = 5;
    else if (section == 3)
        offset = 8;
    return offset;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        if (section == 0)
            return @"Jpoint-Tpeak Interval";
        else if (section == 1)
            return @"Clinical History";
        else if (section == 2)
            return @"Family History";
        else
            return @"Genotype";
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = [self calculateOffset:indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.risks objectAtIndex:indexPath.row + offset] setIsSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
        [[self.risks objectAtIndex:indexPath.row + offset] setIsSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
