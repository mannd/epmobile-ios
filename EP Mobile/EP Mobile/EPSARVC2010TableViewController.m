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
@synthesize headers;
@synthesize criteria;

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
    NSDictionary *arvcDictionary = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"ARVC"]];
    NSArray *headerArray = [[NSArray alloc] initWithArray:[arvcDictionary objectForKey:@"SectionHeaders"]] ;
    self.headers = headerArray;
    
    NSArray *arvcCriteriaArray = [[NSArray alloc] initWithArray:[dictionary objectForKey:self.criteria]];
    NSMutableArray *risks = [[NSMutableArray alloc] init];

    for (int i = 0; i < [arvcCriteriaArray count]; ++i) {
        // init each section
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[arvcCriteriaArray objectAtIndex:i] count]; ++j) {
            EPSRiskFactor *risk = [[EPSRiskFactor alloc] initWithDetails:[[[arvcCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:0] withValue:[[[[arvcCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:1] integerValue]  withDetails:@""];
            
         
            [tmpArray addObject:risk];
        }
        [risks addObject:tmpArray];
    }

    self.list = risks;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.list = nil;
    self.criteria = nil;
    self.headers = nil;
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
    return [headers objectAtIndex:section];
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
    NSString *text = [[[self.list objectAtIndex:section] objectAtIndex:row ] name];
    cell.detailTextLabel.text = text;
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    if ([[[self.list objectAtIndex:section] objectAtIndex:row] points] == 100)
        cell.textLabel.text = @"MAJOR";
    else
        cell.textLabel.text = @"MINOR";
    BOOL selected = [[[self.list objectAtIndex:section] objectAtIndex:row] selected];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *result = nil;
    if ([criteria isEqualToString:@"ARVC2010"] && section == 0) {
        result = @"BSA = body surface area. PLAX = parasternal long axis view. PSAX = parasternal short axis view. RVOT = RV outflow tract.";
    }
    return result;
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
