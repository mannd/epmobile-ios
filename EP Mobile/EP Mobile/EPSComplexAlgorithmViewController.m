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
#import "EPSSharedMethods.h"
#import "EP_Mobile-Swift.h"

#define v24PosStep 2
#define aVLStep 3
#define bifidIIStep 4
#define negAllInfStep 5
#define negAllInf2Step 6
#define sinusRhythmPStep 7

@interface EPSComplexAlgorithmViewController ()

@end

@implementation EPSComplexAlgorithmViewController  {
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
    self.step = 1;
    [self setButtons];
    self.questionLabel.text = [algorithm step1];

    self.button1.configuration = [UIButton smallRoundedButtonConfiguration];
    self.button2.configuration = [UIButton smallRoundedButtonConfiguration];
    self.button3.configuration = [UIButton smallRoundedButtonConfiguration];
    self.button4.configuration = [UIButton smallRoundedButtonConfiguration];
    self.button5.configuration = [UIButton smallRoundedButtonConfiguration];
    self.button6.configuration = [UIButton smallRoundedButtonConfiguration];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// his information really should be hidden in the algorithm, not view controller
- (void) setButtons {
    if (step == 1) {
        self.button4.hidden = NO;
        self.button5.hidden = NO;
        self.button6.hidden = NO;
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

- (void)showNotes {
    [InformationViewController
     showWithVc:self
     instructions:@"This algorithm applies only to focal atrial tachycardia. To be accurate, the P wave must have a discrete isoelectric segment before its start, i.e. don\'t use a P wave that is fused onto the end of a T wave.  Iso means isoelectric, defined as a < 0.05 mV deviation from the baseline.  The algorithm sensitivity in the original study was 93%."
     key:NULL
     references:[NSArray arrayWithObject:[[Reference alloc] init:@"Kistler PM, Roberts-Thomson Kurt C., Haqqani HM, et al. P-Wave Morphology in Focal Atrial Tachycardia. Journal of the American College of Cardiology. 2006;48(5):1010-1017.\ndoi:/10.1016/j.jacc.2006.03.058"]]
     name:[algorithm name]];
}

- (void)showResults {
    NSString *details = [algorithm outcome:step];
    NSString *title = [algorithm resultDialogTitle];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self->algorithm resetSteps:&self->step];
        self.questionLabel.text = [self->algorithm step1];
        [self setButtons];
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
