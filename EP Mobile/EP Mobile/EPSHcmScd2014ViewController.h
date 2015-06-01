//
//  EPSHcmScd2014ViewController.h
//  EP Mobile
//
//  Created by David Mann on 5/30/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSHcmScd2014ViewController : UIViewController
    <UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *risks;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *thicknessTextField;
@property (strong, nonatomic) IBOutlet UITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet UITextField *gradientTextField;
@property (strong, nonatomic) IBOutlet UISwitch *familyHxSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *nsvtSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *syncopeSwitch;
- (IBAction)calculate:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
