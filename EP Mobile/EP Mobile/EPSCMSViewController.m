//
//  EPSCMSViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/18/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCMSViewController.h"
#import "EPSCMSNotes.h"
#import "EPSNotesViewController.h"
#import "EPSRiskFactor.h"

// these magic numbers are in Data.plist
#define CARDIAC_ARREST 0
#define SUS_VT 1
#define FAMILIAL_CONDITION 2
#define ISCHEMIC_CM 3
#define NONISCHEMIC_CM 4
#define LONG_DURATION_CM 5
#define MI 6
#define INDUCIBLE_VT 7
#define QRS_DURATION_LONG 8
#define CARDIOGENIC_SHOCK 9
#define RECENT_CABG 10
#define RECENT_MI 11
#define RECENT_MI_EPS 12
#define REVASCULARIZATION_CANDIDATE 13
#define BAD_PROGNOSIS 14
#define BRAIN_DAMAGE 15
#define ABSOLUTE_EXCLUSION 100
#define POSSIBLE_INDICATION 200

#define DEFAULT_CELL_HEIGHT 50
#define BIG_CELL_HEIGHT 80

@interface EPSCMSViewController ()

@end

@implementation EPSCMSViewController
@synthesize efSegmentedControl;
@synthesize hfClassSegmentedControl;
@synthesize criteriaTableView;
@synthesize list;
@synthesize headers;

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *cmsDictionary = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"CMS"]];
    NSArray *headerArray = [[NSArray alloc] initWithArray:[cmsDictionary objectForKey:@"SectionHeaders"]] ;
    self.headers = headerArray;
    
    NSArray *cmsCriteriaArray = [[NSArray alloc] initWithArray:[cmsDictionary objectForKey:@"Sections"]];
    NSMutableArray *risks = [[NSMutableArray alloc] init];
    for (int i = 0; i < [cmsCriteriaArray count]; ++i) {
        // init each section
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[cmsCriteriaArray objectAtIndex:i] count]; ++j) {
            EPSRiskFactor *risk = [[EPSRiskFactor alloc] initWith:[[[cmsCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:0] withValue:[[[[cmsCriteriaArray objectAtIndex:i] objectAtIndex:j] objectAtIndex:1] integerValue]];
            
            
            [tmpArray addObject:risk];
        }
        [risks addObject:tmpArray];
    }
    
    self.list = risks;
    
    [self.efSegmentedControl setTitle:@">35"forSegmentAtIndex:0];
        [self.efSegmentedControl setTitle:@">30&≤35"forSegmentAtIndex:1];
        [self.efSegmentedControl setTitle:@"≤30"forSegmentAtIndex:2];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEfSegmentedControl:nil];
    [self setHfClassSegmentedControl:nil];
    [self setCriteriaTableView:nil];
    self.list = nil;
    self.headers = nil;
    [super viewDidUnload];
}

- (void)showNotes {
    [self performSegueWithIdentifier:@"CMSNotesSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"CMSNotesSegue"]) {
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"CMSNotes";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.headers count];
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
    static NSString *CellIdentifier = @"CMSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
   
    NSString *text = [[[self.list objectAtIndex:section] objectAtIndex:row ] name];
    cell.textLabel.text = text;
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    BOOL selected = [[[self.list objectAtIndex:section] objectAtIndex:row] selected];
    cell.accessoryType = (selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this is very tweaky
    if (([indexPath section] == 0 && [indexPath row] == 1) ||
        ([indexPath section] == 1 && [indexPath row] == 0))
        return BIG_CELL_HEIGHT;
    else
        return DEFAULT_CELL_HEIGHT;
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
