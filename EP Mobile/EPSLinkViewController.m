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
    if (([self.linkTitle length] > 0)) {
        self.title = self.linkTitle;
    }

    UIBarButtonItem *buttonCalc = [[UIBarButtonItem alloc]initWithTitle:@"CrCl" style:UIBarButtonItemStylePlain target:self action:@selector(calculate)];
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
    if (self.showToolbar) {
        NSString *crClResult = [self getStoredCreatinineClearance];
        self.resultLabel.text = crClResult;
    }
    
}

- (NSString *)getStoredCreatinineClearance {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double age = [userDefaults doubleForKey:@"CC_age"];
    // truncate age to integer
    int ageTruncated = (int)age;
    // if ageTruncated == 0, abort, just return empty string
    if (ageTruncated == 0) {
        return @"";
    }
    NSString *ageString = [NSString stringWithFormat:@"%dy", ageTruncated];
    
    BOOL isMale = [userDefaults boolForKey:@"CC_is_male"];
    NSString *sexString = (isMale ? @"M " : @"F ");
    
    double weightInKgs = [userDefaults doubleForKey:@"CC_weight_in_kgs"];
    int weightTruncated = (int)weightInKgs;
    NSString *weightString = [NSString stringWithFormat:@"%dkg ", weightTruncated];
    
    double creatinine = [userDefaults doubleForKey:@"CC_creatinine"];
    NSString *creatinineString = [NSString stringWithFormat:@"Cr %.3gml/dL)", creatinine];
    
    double crCl = [userDefaults doubleForKey:@"CC_creatinine_clearance"];
    NSString *crClString = [NSString stringWithFormat:@"%.0fml/min (", crCl];
    
    NSString *result = @"";
    result = [result stringByAppendingString:crClString];

    result = [result stringByAppendingString:ageString];
    result = [result stringByAppendingString:sexString];
    result = [result stringByAppendingString:weightString];
    result = [result stringByAppendingString:creatinineString];
    
    return result;
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
