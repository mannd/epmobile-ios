//
//  EPSComplexAlgorithmViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/25/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSComplexAlgorithmViewController.h"

@interface EPSComplexAlgorithmViewController ()

@end

@implementation EPSComplexAlgorithmViewController

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
- (IBAction)button1Click:(id)sender {
}

- (IBAction)button2Click:(id)sender {
}

- (IBAction)button3Click:(id)sender {
}

- (IBAction)button4Click:(id)sender {
}

- (IBAction)button5Click:(id)sender {
}

- (IBAction)button6Click:(id)sender {
}

- (IBAction)instructionsButtonClick:(id)sender {
}
@end
