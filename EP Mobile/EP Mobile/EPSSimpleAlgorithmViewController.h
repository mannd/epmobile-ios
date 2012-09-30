//
//  EPSSimpleAlgorithmViewController.h
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSimpleAlgorithmViewController : UIViewController
@property (strong, nonatomic) NSString *algorithm;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *instructionsButton;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;


- (IBAction)yesButtonPushed:(id)sender;
- (IBAction)noButtonPushed:(id)sender;
- (IBAction)backButtonPushed:(id)sender;
@end
