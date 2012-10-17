//
//  EPSSimpleAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSSimpleAlgorithmViewController.h"
#import "EPSNotesViewController.h"
#import "EPSStepAlgorithmProtocol.h"
#import "EPSOutflowVTAlgorithm.h"
#import "EPSAnnularVTAlgorithm.h"
#import "EPSBrugadaWCTAlgorithm.h"

#define OUTFLOW_VT @"OutflowVT"
#define ANNULAR_VT @"AnnularVT"
#define BRUGADA_WCT @"BrugadaWCT"

@interface EPSSimpleAlgorithmViewController ()

@end

@implementation EPSSimpleAlgorithmViewController{
    id<EPSStepAlgorithmProtocol> algorithm;
}
@synthesize algorithmName;
@synthesize backButton;
@synthesize instructionsButton;
@synthesize questionLabel;
@synthesize step;
@synthesize yesButton;
@synthesize noButton;

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
    
    if ([self.algorithmName isEqualToString:OUTFLOW_VT])
        algorithm = [[EPSOutflowVTAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:ANNULAR_VT])
        algorithm = [[EPSAnnularVTAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:BRUGADA_WCT])
        algorithm = [[EPSBrugadaWCTAlgorithm alloc] init];
    self.navigationItem.title = [algorithm name];
        
    // ...
    // disabled buttons aren't automatically grayed out in iOS
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.instructionsButton.hidden = ![algorithm showInstructionsButton];
    [self.instructionsButton setTitle:
         @"Instructions" forState:UIControlStateNormal];
    step = 1;
    [self setButtons];
    self.questionLabel.text = [algorithm step1];
}

- (void)viewDidUnload
{
    self.algorithmName = nil;
    [self setBackButton:nil];
    [self setQuestionLabel:nil];
    [self setInstructionsButton:nil];
    [self setYesButton:nil];
    [self setNoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)yesButtonPushed:(id)sender {
    NSString *question = [algorithm yesResult:&step];
    [self setButtons];
    if (step != SUCCESS_STEP)
        self.questionLabel.text = question;
    else
        [self showResults];
}

- (IBAction)noButtonPushed:(id)sender {
    NSString *question = [algorithm noResult:&step];
    [self setButtons];
    if (step != SUCCESS_STEP)
        self.questionLabel.text = question;
    else
        [self showResults];
}

- (IBAction)backButtonPushed:(id)sender {
    NSString *question = [algorithm backResult:&step];
    [self setButtons];
    if (step == 1) {
        self.questionLabel.text = [algorithm step1];
        }
    else
        self.questionLabel.text = question;
   
}

- (void)setButtons {
    self.backButton.enabled = (step != 1);
    if (step == SPECIAL_STEP_1) {
        [self.yesButton setTitle:@"RV" forState:UIControlStateNormal];
        [self.noButton setTitle:@"LV" forState:UIControlStateNormal];
    }
    else {
        [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [self.noButton setTitle:@"No" forState:UIControlStateNormal];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
    vc.key = self.algorithmName;
}

- (void)showResults {
    NSString *details = [algorithm outcome:0];
    NSString *title = [algorithm resultDialogTitle];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:details delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

  
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0) {
        NSLog(@"Button index = %d", buttonIndex);
        [algorithm resetSteps:&step];
        self.backButton.enabled = NO;
        self.questionLabel.text = [algorithm step1];
    }
}



@end
