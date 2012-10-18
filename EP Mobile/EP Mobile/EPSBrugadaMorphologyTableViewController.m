//
//  EPSBrugadaMorphologyTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaMorphologyTableViewController.h"
#import "EPSRiskFactor.h"

#define LBBB_TAG 0
#define RBBB_TAG 1

@interface EPSBrugadaMorphologyTableViewController ()

@end

@implementation EPSBrugadaMorphologyTableViewController
@synthesize list;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *lbbbArray = [[NSArray alloc] initWithObjects:@"R > 30 msec in V1 or V2", @"Onset to nadir S > 60 msec in V1 or V2", @"Notched or slurred S in V1 or V2",@"QR or QR in V6", nil];
    NSArray *rbbbArray = [[NSArray alloc] initWithObjects:@"Monophasic R in V1", @"QR in V1", @"RS in V1", @"R to S ration < 1 in V6", @"Monophasic R in V6", nil];
    
    NSMutableArray *lbbbRisks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [lbbbArray count]; ++i) {
        EPSRiskFactor *risk = [[EPSRiskFactor alloc] initWith:[lbbbArray objectAtIndex:i] withValue:1];
        [lbbbRisks addObject:risk];
    }
    NSMutableArray *rbbbRisks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [rbbbArray count]; ++i) {
        EPSRiskFactor *risk = [[EPSRiskFactor alloc] initWith:[rbbbArray objectAtIndex:i] withValue:1];
        [rbbbRisks addObject:risk];
    }
    if (self.view.tag == LBBB_TAG)
        self.list = lbbbRisks;
    else
        self.list = rbbbRisks;
    
    
    
    UIBarButtonItem *editButton = self.tabBarController.navigationItem.rightBarButtonItem;
    [editButton setTarget:self];
    [editButton setAction:@selector(calculateScore)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.list = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateScore {
    NSLog(@"Calculating score...");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:@"test" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *text = [[self.list objectAtIndex:row] name];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    BOOL selected = [[self.list objectAtIndex:row] selected];
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
        [[self.list objectAtIndex:row] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.list objectAtIndex:row] setSelected:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
