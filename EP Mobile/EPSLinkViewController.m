//
//  EPSLinkViewViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/23/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSLinkViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"

@interface EPSLinkViewController ()

@end

@implementation EPSLinkViewController

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
    [self.webView setScalesPageToFit:YES];
    NSString *urlAddress= self.webPage;
    NSURL *url = nil;
    if ([urlAddress hasPrefix:@"http"]) {
        url = [NSURL URLWithString:urlAddress];
    }
    else {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:urlAddress ofType:@"html"] isDirectory:NO];
        [self.webView setScalesPageToFit:NO];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    if (([self.drugTitle length] > 0)) {
        self.title = self.drugTitle;
    }
    
    UIBarButtonItem *buttonCalc = [[UIBarButtonItem alloc]initWithTitle:@"Calc CrCL" style:UIBarButtonItemStylePlain target:self action:@selector(calculate)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 25, self.view.frame.size.width, 21.0f)];
    self.resultLabel = label;
    label.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.toolbarItems = [NSArray arrayWithObjects: buttonCalc, labelItem, nil];
    label.text = @"";


}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:!self.showToolbar];
    // test for non-zero crcl, if so, update resultLabel.text
    //self.resultLabel.text = @"Crcl performed";
    
}

- (void)calculate {
    [self performSegueWithIdentifier:@"calcCreatinineClearanceSegue" sender:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSDrugDoseCalculatorViewController *drugDoseViewController = (EPSDrugDoseCalculatorViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"calcCreatinineClearanceSegue"])
        drugDoseViewController.drug = @"Creatinine Clearance";
}
@end
