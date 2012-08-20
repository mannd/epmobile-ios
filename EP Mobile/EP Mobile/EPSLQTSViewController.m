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
    [qtcSegmentedControl setTitle:@"< 450" forSegmentAtIndex:0];
    [qtcSegmentedControl setTitle:@"450" forSegmentAtIndex:1];
    [qtcSegmentedControl setTitle:@"≥ 460" forSegmentAtIndex:2];
    [qtcSegmentedControl setTitle:@"≥ 480" forSegmentAtIndex:3];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Torsade de pointes" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"T wave alternans" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Notched T wave in 3 leads" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Low heart rate for age" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope with stress" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope without stress" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Congenital deafness" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Family member with definite LQTS" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained SCD immediate family < 30 y/o" withValue:1]];
 
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return  4;
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
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    int offset = [self calculateOffset:indexPath.section];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    //NSString *details = [[self.risks objectAtIndex:indexPath.row ] details];
    cell.textLabel.text = risk;
    //cell.detailTextLabel.text = details;
    return cell;
}

- (int)calculateOffset:(int)section {
    int offset = 0;
    if (section == 1)
        offset = 4;
    else if (section == 2)
        offset = 7;
    return offset;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = [self calculateOffset:indexPath.section];
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
