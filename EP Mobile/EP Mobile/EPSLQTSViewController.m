//
//  EPSLQTSViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLQTSViewController.h"
#import "EPSRiskFactor.h"

@interface EPSLQTSViewController ()

@end

@implementation EPSLQTSViewController
@synthesize qtcSegmentedControl;
@synthesize sexSegmentedControl;
@synthesize riskTableView;

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
    [self.qtcSegmentedControl setTitle:@"< 450" forSegmentAtIndex:0];
    [self.qtcSegmentedControl setTitle:@"450" forSegmentAtIndex:1];
    [self.qtcSegmentedControl setTitle:@"≥ 460" forSegmentAtIndex:2];
    [self.qtcSegmentedControl setTitle:@"≥ 480" forSegmentAtIndex:3];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"QTc 4 min post-ex test ≥ 480 msec" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Torsade de pointes" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"T wave alternans" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Notched T wave in 3 leads" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Low heart rate for age" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope with stress" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope without stress" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Congenital deafness" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Family member with definite LQTS" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained SCD immediate family < 30 y/o" withValue:5]];
 
    self.risks = array;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;


}

- (void)viewDidUnload
{
    [self setQtcSegmentedControl:nil];
    [self setSexSegmentedControl:nil];
    [self setRiskTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

// for iOS 6
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void) calculateScore {
    // since this score uses 0.5, we will multiply points by 10, e.g.
    // 1 = 10, to avoid using non-integer arithmetic
    const int MALE = 0;
    // const int FEMALE = 1;

    // const int NORMAL_QTC = 0;
    const int MILD_QTC_PROLONGATION = 1;
    const int MOD_QTC_PROLONGATION = 2;
    const int MARKED_QTC_PROLONGATION = 3;
    
    const int HAS_TORSADE_INDEX = 1;
    const int HAS_SYNCOPE_WITH_STRESS_INDEX = 5;
    const int HAS_SYNCOPE_WITHOUT_STRESS_INDEX = 6;
    
    int score = 0;
    
    if ([self.qtcSegmentedControl selectedSegmentIndex] == MILD_QTC_PROLONGATION
         && [sexSegmentedControl selectedSegmentIndex] == MALE)
        score += 10;
    else if ([self.qtcSegmentedControl selectedSegmentIndex] == MOD_QTC_PROLONGATION)
        score += 20;
    else if ([self.qtcSegmentedControl selectedSegmentIndex] == MARKED_QTC_PROLONGATION)
        score += 30;
    for (int i = 0; i < [self.risks count]; ++i)
        if ([[self.risks objectAtIndex:i] selected] == YES)
            score += [[self.risks objectAtIndex:i] points];
    

    // Torsade and syncope are mutually exclusive, so don't count syncope
    // if has torsade.
	if ([[self.risks objectAtIndex:HAS_TORSADE_INDEX] selected] && ([[self.risks objectAtIndex:HAS_SYNCOPE_WITH_STRESS_INDEX] selected] || [[self.risks objectAtIndex:HAS_SYNCOPE_WITHOUT_STRESS_INDEX] selected])) {
        if ([[self.risks objectAtIndex:HAS_SYNCOPE_WITH_STRESS_INDEX] selected])
            score -= 20;
        if ([[self.risks objectAtIndex:HAS_SYNCOPE_WITHOUT_STRESS_INDEX] selected])
            score -= 10;
    }  
    // Not allowed to have syncope with and without stress, count it as syncope with stress
    // (radio buttons would fix this, but not available in iOS)
    else if ([[self.risks objectAtIndex:HAS_SYNCOPE_WITH_STRESS_INDEX] selected] && [[self.risks objectAtIndex:HAS_SYNCOPE_WITHOUT_STRESS_INDEX] selected])
        // subtract the points for syncope without stress
        score -= 10;
        
    NSString *message = [self getResultsMessage:score];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    // left justify message
    //((UILabel *)[[alertView subviews] objectAtIndex:1]).textAlignment = UITextAlignmentLeft;
    [alertView show];
}
    
- (NSString *)getResultsMessage:(int)score {
    double displayScore = score / 10.0;
    NSString *message = [[NSString alloc] initWithFormat:@"Risk Score = %1.1f\n", displayScore];
    if (score >= 35)
        message = [[NSString alloc] initWithFormat:@"%@High probability of ", message];
    else if (score >= 15)
        message = [[NSString alloc] initWithFormat:@"%@Intermediate probability of ", message];
    else
        message = [[NSString alloc] initWithFormat:@"%@Low probability of ", message];
    message = [[NSString alloc] initWithFormat:@"%@Long QT Syndrome", message];


    return message;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return  5;
    else if (section == 1)
        return  3;
    else {
        return 2;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"ECG Findings";
    else if (section == 1)
        return @"Clinical History";
    else 
        return @"Family History";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LQTCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LQTCell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    int offset = [self calculateOffset:indexPath.section];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    //NSString *details = [[self.risks objectAtIndex:indexPath.row ] details];
    cell.textLabel.text = risk;
    if ([[self.risks objectAtIndex:(indexPath.row + offset)] selected] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    //cell.detailTextLabel.text = details;
    return cell;
}

- (int)calculateOffset:(int)section {
    int offset = 0;
    if (section == 1)
        offset = 5;
    else if (section == 2)
        offset = 8;
    return offset;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = [self calculateOffset:indexPath.section];
    NSLog(@"Offset = %d section = %d row = %d", offset, indexPath.section, indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.risks objectAtIndex:indexPath.row + offset] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.risks objectAtIndex:indexPath.row + offset] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







@end
