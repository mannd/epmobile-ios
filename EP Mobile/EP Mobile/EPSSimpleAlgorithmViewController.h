//
//  EPSSimpleAlgorithmViewController.h
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EP_Mobile-Swift.h"

@interface EPSSimpleAlgorithmViewController : UIViewController
@property (strong, nonatomic) NSString *algorithmName;
@property (strong, nonatomic) NSArray *references;
@property (strong, nonatomic) NSString *instructions;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *instructionsButton;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;
@property (strong, nonatomic) IBOutlet UIButton *morphologyCriteriaButton;

@property int step;


- (IBAction)yesButtonPushed:(id)sender;
- (IBAction)noButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;
@end
