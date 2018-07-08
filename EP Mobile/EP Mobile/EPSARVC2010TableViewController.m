//
//  EPSARVC2010TableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/3/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSARVC2010TableViewController.h"
#import "EPSRiskFactor.h"
#import "EPSLogging.h"
#import "EPSSharedMethods.h"

#define SECTION_0_HEADER @"I. Global/Regional Dysfunction and Structural Alterations"
#define SECTION_1_HEADER @"II. Tissue Characterizations of Wall"
#define SECTION_2_HEADER @"III. Repolarization Abnormalities"
#define SECTION_3_HEADER @"IV. Depolarization and Conduction Abnormalities"
#define SECTION_4_HEADER @"V. Arrhythmias"
#define SECTION_5_HEADER @"VI. Family History"

#define ARVC_2010_CELL_HEIGHT 150
#define ARVC_1994_CELL_HEIGHT 100

@interface EPSARVC2010TableViewController ()

@end

@implementation EPSARVC2010TableViewController
{
    int cellHeight;
}
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
    
    if ([self.criteria isEqualToString:@"ARVC1994"]) {
        cellHeight = ARVC_1994_CELL_HEIGHT;
        self.navigationItem.title = @"ARVC/D 1994";
    }
    else
        cellHeight = ARVC_2010_CELL_HEIGHT;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStylePlain target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
    
}

- (void)calculateScore {
    int major = 0;
    int minor = 0;
    for (int i = 0; i < [self.list count]; ++i) {
        int tmp = 0;
        for (int j = 0; j < [[self.list objectAtIndex:i] count]; ++j) {
            if ([[[self.list objectAtIndex:i] objectAtIndex:j] selected]) {
                tmp += [[[self.list objectAtIndex:i] objectAtIndex:j] points];
            }
        }
        if ([self.criteria isEqualToString:@"ARVC2010"]) {
            // only one major and minor risk factor counted for each section
            major += (tmp / 100) >= 1 ? 1 : 0;
            minor += (tmp % 100) >= 1 ? 1 : 0;
        }
        else {
            // each major and minor counted with 1994 criteria
            major += tmp / 100;
            minor += tmp % 100;
        }
    }
    EPSLog(@"major = %d", major);
    EPSLog(@"minor = %d", minor);
    
    [EPSSharedMethods showDialogWithTitle:@"Risk Score" andMessage:[self getResultMessage:major :minor] inView:self];
    
}

- (NSString *)getResultMessage:(int)major :(int)minor {
    if ([self.criteria isEqualToString:@"ARVC2010"])
        return [self getArvc2010ResultMessage:major :minor];
    else
        return [self getArvc1994ResultMessage:major :minor];
}

- (NSString *)getArvc2010ResultMessage:(int) major :(int)minor {
    NSString *message;
    NSString *messageStart = [[NSString alloc] initWithFormat:@"Major = %d\nMinor = %d\n", major, minor];
    if (major >= 2 || (major == 1 && minor >= 2) || minor >= 4)
        message = [messageStart stringByAppendingString:@"Definite diagnosis of ARVC/D"];
    else if ((major == 1 && minor >= 1) || minor == 3)
        message = [messageStart stringByAppendingString:@"Borderline diagnosis of ARVC/D"];
    else if (major == 1 || minor == 2)
        message = [messageStart stringByAppendingString:@"Possible diagnosis of ARVC/D"];
    else
        message = [messageStart stringByAppendingString:@"Not diagnostic of ARVC/D"];
    return message;
}

- (NSString *)getArvc1994ResultMessage:(int)major :(int)minor {
    NSString *message;
    NSString *messageStart = [[NSString alloc] initWithFormat:@"Major = %d\nMinor = %d\n", major, minor];
    if (major > 1 || (major > 0 && minor > 1) || minor > 3)
        message = [messageStart stringByAppendingString:@"Diagnostic of ARVC/D"];
    else
        message = [messageStart stringByAppendingString:@"Not Diagnostic of ARVC/D"];
    return message;
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
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
    return cellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *result = nil;
    if ([criteria isEqualToString:@"ARVC2010"] && section == 0) {
        result = @"BSA = body surface area. PLAX = parasternal long axis view. PSAX = parasternal short axis view. RVOT = RV outflow tract.";
    }
    if (section == 5) {
        if ([criteria isEqualToString:@"ARVC2010"])
            result = @"Reference: Marcus FI et al. Circulation 2010;121:1533.";
        else
            result = @"Reference: McKenna WJ et al. Br Heart J 1994;71:215.";
            
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
