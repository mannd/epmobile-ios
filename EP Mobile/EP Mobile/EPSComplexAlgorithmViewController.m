//
//  EPSComplexAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/25/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSComplexAlgorithmViewController.h"


#define v24PosStep 2
#define aVLStep 3
#define bifidIIStep 4
#define negAllInfStep 5
#define negAllInf2Step 6
#define sinusRhythmPStep 7

@interface EPSComplexAlgorithmViewController ()

@end

@implementation EPSComplexAlgorithmViewController
{
    int priorStep, priorStep1, priorStep2, priorStep3, priorStep4, priorStep5, priorStep6, priorStep7;
  
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
    priorStep = priorStep1 = priorStep2 = priorStep3 = priorStep4 = priorStep5 = priorStep6 = priorStep7 = 1;
    self.step = 1;
    [self setButtons];
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

- (void) step1 {
    self.questionLabel.text = @"P Wave Morphology in Lead V1?";
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

- (void) getYesResult {
    switch (self.step) {
        case 1:
            self.step = v24PosStep;
            break;
    }
    [self setButtons];
    
}

- (void) getNoResult {
    switch (self.step) {
        case 1:
            [self showResults:@"Crista Terminalis"];
            break;
    }
    [self setButtons];
}

- (void) getBackResult {
    if (step == 1)
        step = aVLStep;
    else
        [self adjustStepsBackwards];
    [self setButtons];
}

- (void) adjustStepsBackwards {
    switch (step) {
		case v24PosStep:
		case aVLStep:
		case bifidIIStep:
			step = 1;
			break;
		case negAllInfStep:
			step = v24PosStep;
			break;
		case negAllInf2Step:
		case sinusRhythmPStep:
			step = bifidIIStep;
			break;
    }

}

- (void) setButtons {
    if (step == 1)
        [self step1];
    else {   // step > 1
        self.button4.hidden = YES;
        self.button5.hidden = YES;
        self.button6.hidden = YES;
        self.instructionsButton.hidden = YES;
        [self.button1 setTitle:@"Yes" forState:UIControlStateNormal];
        [self.button2 setTitle:@"No" forState:UIControlStateNormal];
        [self.button3 setTitle:@"Back" forState:UIControlStateNormal];
    }
}

- (IBAction)button1Click:(id)sender {
    [self getYesResult];
}

- (IBAction)button2Click:(id)sender {
    [self getNoResult];
}

- (IBAction)button3Click:(id)sender {
    [self getBackResult];
}

- (IBAction)button4Click:(id)sender {
    [self showResults:@"Right Side of Septum or Perinodal"];
}

- (IBAction)button5Click:(id)sender {
}

- (IBAction)button6Click:(id)sender {
}

- (IBAction)instructionsButtonClick:(id)sender {
}

- (void)showResults:(NSString *)details {
    NSString *title = @"Atrial Tachycardia Location";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:details delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    step = 1;
    [self setButtons];
}


@end
