//
//  EPSComplexAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/25/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSComplexAlgorithmViewController.h"
#import "EPSAtrialTachAlgorithm.h"
#import "EPSNotesViewController.h"
#import "EPSComplexStepAlgorithmProtocol.h"
#import "EPSLogging.h"

#define v24PosStep 2
#define aVLStep 3
#define bifidIIStep 4
#define negAllInfStep 5
#define negAllInf2Step 6
#define sinusRhythmPStep 7

@interface EPSComplexAlgorithmViewController ()

@end

@implementation EPSComplexAlgorithmViewController {
    id<EPSComplexStepAlgorithmProtocol> algorithm;
  
}

@synthesize step;

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
    // Assumes only one algorithm uses this controller, see EPSSimpleAlgorithmViewController
    // if need to use for more than this algorithm.
    algorithm = [[EPSAtrialTachAlgorithm alloc] init];
    self.navigationItem.title = [algorithm name];
    self.instructionsButton.hidden = ![algorithm showInstructionsButton];
    if (!self.instructionsButton.hidden)
        [self.instructionsButton setTitle:@"Instructions" forState:UIControlStateNormal];
    self.step = 1;
    [self setButtons];
    self.questionLabel.text = [algorithm step1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuestionLabel:nil];
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setButton5:nil];
    [self setButton6:nil];
    [self setInstructionsButton:nil];
    [super viewDidUnload];
}

// his information really should be hidden in the algorithm, not view controller
- (void) setButtons {
    if (step == 1) {
        self.button4.hidden = NO;
        self.button5.hidden = NO;
        self.button6.hidden = NO;
        self.instructionsButton.hidden = NO;
        [self.button1 setTitle:@"Neg" forState:UIControlStateNormal];
        [self.button2 setTitle:@"Pos/Neg" forState:UIControlStateNormal];
        [self.button3 setTitle:@"Neg/Pos" forState:UIControlStateNormal];
        [self.button4 setTitle:@"Iso/Pos" forState:UIControlStateNormal];
        [self.button5 setTitle:@"Iso" forState:UIControlStateNormal];
        [self.button6 setTitle:@"Pos" forState:UIControlStateNormal];

    }
    else {   // step > 1
        self.button4.hidden = YES;
        self.button5.hidden = YES;
        self.button6.hidden = YES;
        self.instructionsButton.hidden = YES;
        [self.button1 setTitle:@"Yes" forState:UIControlStateNormal];
        [self.button2 setTitle:@"No" forState:UIControlStateNormal];
        [self.button3 setTitle:@"Back" forState:UIControlStateNormal];
    }

    if (step == aVLStep) {
        [self.button1 setTitle:@"Neg" forState:UIControlStateNormal];
        [self.button2 setTitle:@"Pos" forState:UIControlStateNormal];
    }
    if (step == sinusRhythmPStep) {
        [self.button1 setTitle:@"Pos" forState:UIControlStateNormal];
        [self.button2 setTitle:@"Pos/Neg" forState:UIControlStateNormal];
    }
}

- (IBAction)button1Click:(id)sender {
    NSString *question = [algorithm yesResult:&step];
    if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}

- (IBAction)button2Click:(id)sender {
    NSString *question = [algorithm noResult:&step];
      if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}

- (IBAction)button3Click:(id)sender {
    NSString *question = [algorithm backResult:&step];
       if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}

- (IBAction)button4Click:(id)sender {
    NSString *question = [algorithm button4Result:&step];
     if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}

- (IBAction)button5Click:(id)sender {
    NSString *question = [algorithm button5Result:&step];
    if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}

- (IBAction)button6Click:(id)sender {
    NSString *question = [algorithm button6Result:&step];
    if (step >= SUCCESS_STEP)    // locations
        [self showResults];
    else {
        [self setButtons];
        self.questionLabel.text = question;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"AtrialTachNotesSegue"]) {
        EPSNotesViewController *vc = (EPSNotesViewController *)[segue destinationViewController];
        vc.key = @"AtrialTachNotes";
    }
}


- (void)showResults {
    NSString *details = [algorithm outcome:step];
    NSString *title = [algorithm resultDialogTitle];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:details delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    EPSLog(@"Button index = %ld", (long)buttonIndex);
    [algorithm resetSteps:&step];
    [self setButtons];
    self.questionLabel.text = [algorithm step1];
}



@end
