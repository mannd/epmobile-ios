//
//  EPSBrugadaMorphologyTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaMorphologyViewController.h"
#import "EPSRiskFactor.h"
#import "EPSLogging.h"
#import "EP_Mobile-Swift.h"

#define LBBB_TAG 0
#define RBBB_TAG 1

#define IN_V1 1
#define IN_V6 100

@interface EPSBrugadaMorphologyViewController ()

@end

@implementation EPSBrugadaMorphologyViewController
@synthesize list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initList {
    NSMutableArray *lbbbRisks = [[NSMutableArray alloc] initWithObjects:
                                 [[EPSRiskFactor alloc] initWith:@"R > 30 msec in V1 or V2" withValue:IN_V1],
                                 [[EPSRiskFactor alloc] initWith:@"Onset to nadir S > 60 msec in V1 or V2" withValue:IN_V1],
                                 [[EPSRiskFactor alloc] initWith:@"Notched or slurred S in V1 or V2" withValue:IN_V1],
                                 [[EPSRiskFactor alloc] initWith:@"QR or QR in V6" withValue:IN_V6],
                                 nil];
    NSMutableArray *rbbbRisks = [[NSMutableArray alloc] initWithObjects:
                          [[EPSRiskFactor alloc] initWith:@"Monophasic R in V1" withValue:IN_V1],
                          [[EPSRiskFactor alloc] initWith:@"QR in V1" withValue:IN_V1],
                          [[EPSRiskFactor alloc] initWith:@"RS in V1" withValue:IN_V1],
                          [[EPSRiskFactor alloc] initWith:@"R to S ratio < 1 in V6" withValue:IN_V6],
                          [[EPSRiskFactor alloc] initWith:@"Monophasic R in V6" withValue:IN_V6],
                          nil];

    if (self.view.tag == LBBB_TAG) {
        self.list = lbbbRisks;
    }
    else {
        self.list = rbbbRisks;
    }
}

- (IBAction)calculate:(id)sender {
    [self calculateScore];
}

- (IBAction)clear:(id)sender {
    [self initList];
    [self.table reloadData];
}

- (void)calculateScore {
    
    int count = 0;
    for (int i = 0; i < [self.list count]; ++i)
        if ([[self.list objectAtIndex:i] isSelected])
            count += [[self.list objectAtIndex:i] points];
    BOOL inV1 = count % 100 > 0;
    BOOL inV6 = count / 100 > 0;
    BOOL isVT = inV1 && inV6;
    NSString *message = @"Wide Complex Tachycardia is most likely ";
    NSString *sens = @".987";
    NSString *spec = @".965";
    if (isVT) {
        message = [message stringByAppendingString:@"Ventricular Tachycardia"];
    }
    else
        message = [message stringByAppendingString:@"Supraventricular Tachycardia"];
    message = [message stringByAppendingFormat:@" (Sens=%@, Spec=%@) ", sens, spec];
    
    EPSLog(@"Calculating score...%d", count);
    [self showSimpleDialogWithTitle:@"WCT Result" message:message];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrugadaMorphologyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *text = [[self.list objectAtIndex:row] name];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    BOOL selected = [[self.list objectAtIndex:row] isSelected];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.list objectAtIndex:row] setIsSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.list objectAtIndex:row] setIsSelected:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
