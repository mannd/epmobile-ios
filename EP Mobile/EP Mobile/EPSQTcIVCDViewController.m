//
//  EPSQTcIVCDViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/23/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTcIVCDViewController.h"

@interface EPSQTcIVCDViewController ()

@end

@implementation EPSQTcIVCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.rateIntervalField resignFirstResponder];
    [self.qtField resignFirstResponder];
    [self.qrsField resignFirstResponder];
    NSLog(@"background tap");
}

- (IBAction)calculateButtonPressed:(id)sender {
    
}

- (IBAction)clearButtonPressed:(id)sender {
    
}

- (IBAction)toggleInputType:(id)sender {
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
