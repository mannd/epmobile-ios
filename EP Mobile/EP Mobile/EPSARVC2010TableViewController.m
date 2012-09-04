//
//  EPSARVC2010TableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/3/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSARVC2010TableViewController.h"
#import "EPSRiskFactor.h"

#define SECTION_0_HEADER @"I. Global/Regional Dysfunction and Structural Alterations"
#define SECTION_1_HEADER @"II. Tissue Characterizations of Wall"
#define SECTION_2_HEADER @"III. Repolarization Abnormalities"
#define SECTION_3_HEADER @"IV. Depolarization and Conduction Abnormalities"
#define SECTION_4_HEADER @"V. Arrhythmias"
#define SECTION_5_HEADER @"VI. Family History"

@interface EPSARVC2010TableViewController ()

@end

@implementation EPSARVC2010TableViewController
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"ARVC2010"]] ;
    
//    // this doesn't work, the members of the array are immutable
//   // self.list = sectionArray;
//    // add the selectable field to each member
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSMutableArray *riskFactorsInSection = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [sectionArray count]; ++i) {
//        [riskFactorsInSection removeAllObjects];    // reset the temp array
//        NSUInteger numRowsInSection = [[sectionArray objectAtIndex:i] count];
//        for (int j = 0; j < numRowsInSection; ++j) {
//            [riskFactorsInSection addObject:[[EPSRiskFactor alloc] initWithDetails:[[[sectionArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:0] withValue:1 withDetails:[[[sectionArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:1]]];
//        }
//        [array addObject:riskFactorsInSection ];
//    }
    // need to create a mutable array for each row, section and the entire array.
    self.list = [sectionArray mutableCopy];
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.list = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.list count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return SECTION_0_HEADER;
        case 1:
            return SECTION_1_HEADER;
        case 2:
            return SECTION_2_HEADER;
        case 3:
            return SECTION_3_HEADER;
        case 4:
            return SECTION_4_HEADER;
        case 5:
        default:
            return SECTION_5_HEADER;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.list objectAtIndex:section ] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ARVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSString *text = [[[self.list objectAtIndex:section] objectAtIndex:row] objectAtIndex:1];
    cell.detailTextLabel.text = text;
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [[[self.list objectAtIndex:section] objectAtIndex:row] objectAtIndex:0];
    BOOL selected = [[[[self.list objectAtIndex:section] objectAtIndex:row] objectAtIndex:2] boolValue];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[(NSMutableArray *)[self.list objectAtIndex:section] objectAtIndex:row] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[(NSMutableArray *)[self.list objectAtIndex:section] objectAtIndex:row] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
