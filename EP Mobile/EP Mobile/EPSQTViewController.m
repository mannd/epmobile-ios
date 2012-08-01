//
//  EPSQTViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/31/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSQTViewController.h"
#import "EPSRiskFactor.h"

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
    [qtcSegmentedControl setTitle:@"\u2265 370" forSegmentAtIndex:0];
    [qtcSegmentedControl setTitle:@"< 370" forSegmentAtIndex:1];
    [qtcSegmentedControl setTitle:@"< 350" forSegmentAtIndex:2];
    [qtcSegmentedControl setTitle:@"< 330" forSegmentAtIndex:3];
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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
    
}

- (void)viewDidUnload
{
    [self setQtcSegmentedControl:nil];

    [self setRiskTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)calculateScore {
    int score = 0;
    if (qtcSegmentedControl.selectedSegmentIndex == 0 && ![[risks objectAtIndex:0] selected]) {
        [self displayResult:score];
        return;
    }

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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
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
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    int offset = 0;
    if (indexPath.section == 1)
        offset = 1;
    else if (indexPath.section == 2)
        offset = 5;
    else if (indexPath.section == 3)
        offset = 8;
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    //NSString *details = [[self.risks objectAtIndex:indexPath.row ] details];
    cell.textLabel.text = risk;
    //cell.detailTextLabel.text = details;
    return cell;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.risks objectAtIndex:indexPath.row] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
        [[self.risks objectAtIndex:indexPath.row] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
