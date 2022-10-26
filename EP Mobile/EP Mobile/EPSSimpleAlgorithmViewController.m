//
//  EPSSimpleAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSSimpleAlgorithmViewController.h"
#import "EPSNotesViewController.h"
//#import "EPSStepAlgorithmProtocol.h"
#import "EPSOutflowVTAlgorithm.h"
#import "EPSAnnularVTAlgorithm.h"
#import "EPSBrugadaWCTAlgorithm.h"
#import "EPSArrudaAlgorithm.h"
#import "EPSModifiedArrudaAlgorithm.h"
#import "EPSMilsteinAlgorithm.h"
#import "EPSAVAnnulusViewController.h"
#import "EPSVereckeiAlgorithm.h"
#import "EPSDavilaAlgorithm.h"
#import "EPSLogging.h"
#import "EP_Mobile-Swift.h"

#define OUTFLOW_VT @"OutflowVT"
#define ANNULAR_VT @"AnnularVT"
#define BRUGADA_WCT @"BrugadaWCT"
#define ARRUDA_WPW @"ArrudaWPW"
#define MILSTEIN_WPW @"MilsteinWPW"
#define MODIFIED_ARRUDA_WPW @"ModifiedArrudaWPW"
#define VERECKEI_WCT @"VereckeiWCT"
#define DAVILA_WPW @"DavilaWPW"

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
@synthesize morphologyCriteriaButton;

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
    else if ([self.algorithmName isEqualToString:ARRUDA_WPW])
        algorithm = [[EPSArrudaAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:MODIFIED_ARRUDA_WPW])
        algorithm = [[EPSModifiedArrudaAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:MILSTEIN_WPW])
        algorithm = [[EPSMilsteinAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:VERECKEI_WCT])
        algorithm = [[EPSVereckeiAlgorithm alloc] init];
    else if ([self.algorithmName isEqualToString:DAVILA_WPW])
        algorithm = [[EPSDavilaAlgorithm alloc] init];
    self.navigationItem.title = [algorithm name];

    // ...
    // disabled buttons aren't automatically grayed out in iOS
    if (@available(iOS 13.0, *)) {
        [self.backButton setTitleColor:[UIColor quaternaryLabelColor] forState:UIControlStateDisabled];
    } else {
        [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    self.instructionsButton.hidden = ![algorithm showInstructionsButton];
    if (!self.instructionsButton.hidden)
        [self.instructionsButton setTitle:@"Instructions" forState:UIControlStateNormal];
    self.morphologyCriteriaButton.hidden = YES;
    step = 1;
    [self setButtons];
    self.questionLabel.text = [algorithm step1];

    self.yesButton.configuration = [UIButton smallRoundedButtonConfiguration];
    self.noButton.configuration = [UIButton smallRoundedButtonConfiguration];
    self.backButton.configuration = [UIButton smallRoundedButtonConfiguration];
    self.morphologyCriteriaButton.configuration = [UIButton smallRoundedButtonConfiguration];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (IBAction)yesButtonPushed:(id)sender {
    NSString *question = [algorithm yesResult:&step];
    [self setButtons];
    if (step < SUCCESS_STEP)
        self.questionLabel.text = question;
    else
        [self showResults];
}

- (IBAction)noButtonPushed:(id)sender {
    NSString *question = [algorithm noResult:&step];
    [self setButtons];
    if (step < SUCCESS_STEP)
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
    // ugly, I know
    self.morphologyCriteriaButton.hidden = !([self.algorithmName isEqualToString:BRUGADA_WCT] && step == 4);
}


// TODO: Check if NotesSegue ever happens
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"NotesSegue"]) {
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = self.algorithmName;
    }
    if ([segueIdentifier isEqualToString:@"MapSegue"]) {
        EPSAVAnnulusViewController *vc = (EPSAVAnnulusViewController *)[segue destinationViewController];
        vc.showPathway = YES;
        vc.location1 = [(EPSArrudaAlgorithm *)algorithm outcomeLocation1:step];
        vc.location2 = [(EPSArrudaAlgorithm *)algorithm outcomeLocation2:step];
        vc.message = [algorithm outcome:step];
    }
}

- (void)showNotes {
    [InformationViewPresenter
     showWithVc:self
     instructions:self.instructions
     key:NULL
     references:self.references
     name:[algorithm name]
    ];
}

- (void)showResults {
    NSString *details = [algorithm outcome:step];
    NSString *title = [algorithm resultDialogTitle];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              [self->algorithm resetSteps:&self->step];
                                                              self.backButton.enabled = NO;
                                                              self.questionLabel.text = [self->algorithm step1];
                                                          }];
    if ([algorithm showMap]) {
        UIAlertAction *showMapAction = [UIAlertAction actionWithTitle:@"Show Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"MapSegue" sender:nil];
            [self->algorithm resetSteps:&self->step];
            self.backButton.enabled = NO;
            self.questionLabel.text = [self->algorithm step1];
        }];
        [alert addAction:showMapAction];
    }
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}



//-    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:details delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//-    [alert show];
//+    [EPSSharedMethods showDialogWithTitle:title andMessage:details inView:self];
//}
//
//-- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    -    NSLog(@"Button index = %d", buttonIndex);
//    -    [algorithm resetSteps:&step];
//    -    [self setButtons];
//    -    self.questionLabel.text = [algorithm step1];
//    -}
//-
//-


@end
