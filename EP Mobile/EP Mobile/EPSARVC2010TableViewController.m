//
//  EPSARVC2010TableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/3/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSARVC2010TableViewController.h"

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
    NSDictionary *rootDictionary = [dictionary objectForKey:@"Root"];
    NSArray *array = [[NSArray alloc] initWithArray:[rootDictionary objectForKey:@"ARVC2010"]];
    
    self.list = array;
    
    
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
    return 6;
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
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ARVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *text = [self.list objectAtIndex:row];
    cell.textLabel.text = text;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
        //[[self.risks objectAtIndex:indexPath.row + offset] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
       // [[self.risks objectAtIndex:indexPath.row + offset] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
