//
//  EPSEntrainmentViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSEntrainmentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tclTextField;
@property (strong, nonatomic) IBOutlet UITextField *ppiTextField;
@property (strong, nonatomic) IBOutlet UISwitch *concealedFusionSwitch;
@property (strong, nonatomic) IBOutlet UILabel *sqrsLabel;
@property (strong, nonatomic) IBOutlet UITextField *sqrsTextField;
@property (strong, nonatomic) IBOutlet UILabel *egqrsLabel;
@property (strong, nonatomic) IBOutlet UITextField *egqrsTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)calculate:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)concealedFusionSwitchValueChanged:(id)sender;

@end
