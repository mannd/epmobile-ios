//
//  EPSRiskScoreTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSRiskScoreTableViewController.h"
#import "EPSRiskFactor.h"

@interface EPSRiskScoreTableViewController ()

@end

@implementation EPSRiskScoreTableViewController
@synthesize risks;
@synthesize scoreType;

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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([scoreType isEqualToString:@"Chads2"]) {
        self.title = @"CHADS\u2082";
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart Failure" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];
    }
    else if ([scoreType isEqualToString:@"ChadsVasc"]) {
        self.title = @"CHA\u2082DS\u2082-VASc";
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Congestive heart failure" withValue:1 withDetails:@"or left ventricular systolic dysfunction"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:2]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];        
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Vascular disease" withValue:1 withDetails:@"e.g. PAD, MI, aortic plaque"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age 65-74 years" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Sex category" withValue:1 withDetails:@"i.e. female gender"]];        
        
    }
    self.risks = array;
 
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.risks = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)calculateScore {
    int score = 0;
    
    for (int i = 0; i < [self.risks count]; ++i)
        if ([[self.risks objectAtIndex:i] selected] == YES)
            score += [[self.risks objectAtIndex:i] points];
    NSString *message = [self getResultsMessage:score];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    ((UILabel *)[[alertView subviews] objectAtIndex:1]).textAlignment = UITextAlignmentLeft;
    [alertView show];
}

- (NSString *)getResultsMessage:(int)result {
    NSString *message = [[NSString alloc] init];
//    if (result < 1)
//        message = getString(R.string.low_chads_message);
//    else if (result == 1)
//        message = getString(R.string.medium_chads_message);
//    else
//        message = getString(R.string.high_chads_message);
    float risk = 0;
    if ([scoreType isEqualToString:@"Chads2"]) {
        switch (result) {
            case 0:
                risk = 1.9;
                break;
            case 1:
                risk = 2.8;
                break;
            case 2:
                risk = 4.0;
                break;
            case 3:
                risk = 5.9;
                break;
            case 4:
                risk = 8.5;
                break;
            case 5:
                risk = 12.5;
                break;
            case 6:
                risk = 18.2;
                break;
        }
    
    NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", risk];
    message = [[NSString alloc] initWithFormat:@"CHADS\u2082 score = %d\n%@\n", result, strokeRisk];
    }
    else if ([scoreType isEqualToString:@"ChadsVasc"]) {
		switch (result) {
            case 0:
                risk = 0;
                break;
            case 1:
                risk = 1.3;
                break;
            case 2:
                risk = 2.2;
                break;
            case 3:
                risk = 3.2;
                break;
            case 4:
                risk = 4.0;
                break;
            case 5:
                risk = 6.7;
                break;
            case 6:
                risk = 9.8;
                break;
            case 7:
                risk = 9.6;
                break;
            case 8:
                risk = 6.7;
                break;
            case 9:
                risk = 15.2;
                break;
		}
        NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", risk];
        message = [[NSString alloc] initWithFormat:@"CHA\u2082DS\u2082-VASc score = %d\n%@\n", result, strokeRisk];
    }
    if (result < 1) 
        message = [message stringByAppendingString:@"\nAnti-platelet drug (ASA) or no drug recommended."];
    else if (result == 1) {
        message = [message stringByAppendingString:@"\nAnti-platelet drug (ASA) or anticoagulation (warfarin, dabigatran or rivaroxaban) recommended."];
        if ([scoreType isEqualToString:@"Chads2"])
            message = [message stringByAppendingString:@"\nRecommend using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
        message = [message stringByAppendingString:@"\nRecommend assessing bleeding score (e.g. with HAS-BLED) to help choose between ASA and anticoagulation."];
    }
    else 
        message = [message stringByAppendingString:@"\nAnticoaguation (warfarin, dabigatran or rivaroxaban) recommended."];
    return message;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [risks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChadsCell"];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row] name];
    NSString *details = [[self.risks objectAtIndex:indexPath.row] details];
    cell.textLabel.text = risk;
    cell.detailTextLabel.text = details;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
