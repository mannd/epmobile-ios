//
//  EPSIcdRiskViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/25/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

// Reference is http://www.onlinejacc.org/content/63/8/788

#import "EPSIcdRiskViewController.h"
#import "EPSRiskFactor.h"
#import "EPSSharedMethods.h"
#import <SafariServices/SafariServices.h>

@interface EPSIcdRiskViewController() <SFSafariViewControllerDelegate>
@end

@implementation EPSIcdRiskViewController

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
    //UIScrollView *scrollView = (UIScrollView *)self.view;
    //float w = self.internalScrollView.bounds.size.width;
    //scrollView.contentSize = CGSizeMake(w, 990);
    //scrollView.delegate = self;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    NSArray *array = [[NSArray alloc] initWithObjects:@"Initial implant", @"Gen change for ERI", @"Gen change for infection", @"Gen change for relocation", @"Gen change for upgrade" , @"Gen change for malfunction", @"Gen change other reason", nil];
    self.procedureTypeData = array;
    
    NSMutableArray *riskArray = [[NSMutableArray alloc] init];
    [riskArray addObject:[[EPSRiskFactor alloc] initWith:@"Female sex" withValue:2]];
    [riskArray addObject:[[EPSRiskFactor alloc] initWith:@"No prior CABG" withValue:2]];
    [riskArray addObject:[[EPSRiskFactor alloc] initWith:@"Current dialysis" withValue:3]];
    [riskArray addObject:[[EPSRiskFactor alloc] initWith:@"Chronic lung disease" withValue:2]];
    self.risks = riskArray;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStylePlain target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.procedureTypePickerView.delegate = self;
    self.otherRisksTableView.delegate = self;
    self.otherRisksTableView.dataSource = self;

    self.referenceLabel.text = @"Reference: Dodson JA, Reynolds MR, Bao H, et al. Developing a Risk Model for In-Hospital Adverse Events Following Implantable Cardioverter-Defibrillator Implantation. Journal of the American College of Cardiology. 2014;63(8):788-796. doi:10.1016/j.jacc.2013.09.079";

    self.title = @"ICD Implantation Risk";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateScore
{
    int score = 0;
    NSInteger row = [self.procedureTypePickerView selectedRowInComponent:0];
    switch (row) {
        case 0:
            score += 13;
            break;
        case 1:
            score += 0;
            break;
        case 2:
            score += 17;
            break;
        case 3:
            score += 18;
            break;
        case 4:
            score += 12;
            break;
        case 5:
            score += 13;
            break;
        case 6:
            score += 14;
            break;
    }
    for (int i = 0; i < [self.risks count]; ++i) {
        if ([self.risks[i] isSelected]) {
            score += [self.risks[i] points];
        }
    }
    NSInteger selection = [self.icdTypeSegmentedControl selectedSegmentIndex];
    if (selection == 1) {
        score += 4; // dual chamber
    }
    else if (selection == 2) {
        score += 6; // CRT-D
    }
    selection = [self.nyhaClassSegmentedControl selectedSegmentIndex];
    if (selection == 1) {
        score += 3; // class III
    }
    else if (selection == 2) {
        score += 7;
    }
    selection = [self.abnormalConductionSegmentedControl selectedSegmentIndex];
    if (selection == 1 || selection == 2) {
        score += 2;
    }
    selection = [self.sodiumSegmentedControl selectedSegmentIndex];
    if (selection == 0) {
        score += 3;
    }
    else if (selection == 2) {
        score += 2;
    }
    selection = [self.hgbSegmentedControl selectedSegmentIndex];
    if (selection == 0) {
        score += 3;
    }
    else if (selection == 1) {
        score += 2;
    }
    selection = [self.bunSegmentedControl selectedSegmentIndex];
    if (selection == 1) {
        score += 2;
    }
    else if (selection == 2) {
        score += 4;
    }
    selection = [self.reasonForAdmissionSegmentedControl selectedSegmentIndex];
    if (selection == 1) {
        score += 4;
    }
    else if (selection == 2) {
        score += 5;
    }
    
    
    NSString *message = [self getResultsMessage:score];
    [EPSSharedMethods showDialogWithTitle:@"Risk of Post-Implant Complications" andMessage:message inView:self];
}

- (NSString *)getResultsMessage:(int)score
{
    int displayScore = score;
    NSString *message = [[NSString alloc] initWithFormat:@"Risk Score = %d\n", displayScore];
    if (score >= 30)
        message = [NSString stringWithFormat:@"%@High probability of in-hospital complications (4.2%%)", message];
    else if (score > 10)
        message = [NSString stringWithFormat:@"%@Intermediate probability of in-hospital complications (0.3-4.2%%)", message];
    else
        message = [NSString stringWithFormat:@"%@Low probability of in-hospital complications (0.3%%)", message];
    
    
    return message;
}

#pragma mark - Picker Data Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.procedureTypeData count];
}


# pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.procedureTypeData objectAtIndex:row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.risks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RiskCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RiskCell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row] name];
    //NSString *details = [[self.risks objectAtIndex:indexPath.row ] details];
    cell.textLabel.text = risk;
    if ([[self.risks objectAtIndex:(indexPath.row)] isSelected] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    //cell.detailTextLabel.text = details;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.risks objectAtIndex:indexPath.row] setIsSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.risks objectAtIndex:indexPath.row] setIsSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Other Risk Factors";
    }
    else {
        return nil;
    }
}

- (IBAction)openReferenceLink:(id)sender {
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[[NSURL alloc] initWithString:@"https://www.sciencedirect.com/science/article/pii/S0735109713062840?via%3Dihubd"]];
    svc.delegate = self;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - SFSafariViewController delegate methods
-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    // Load finished
}
-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // Done button pressed
}

@end
