//
//  EPSQTcIVCDResultsViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/26/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSQTcIVCDResultsViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *qtResult;
@property (weak, nonatomic) IBOutlet UITextField *jtResult;
@property (weak, nonatomic) IBOutlet UITextField *qtcResult;
@property (weak, nonatomic) IBOutlet UITextField *jtcResult;
@property (weak, nonatomic) IBOutlet UITextField *qtmResult;
@property (weak, nonatomic) IBOutlet UITextField *qtmcResult;
@property (weak, nonatomic) IBOutlet UITextField *qtrrqrsResult;

@property NSInteger qt;
@property NSInteger jt;
@property NSInteger qtc;
@property NSInteger jtc;
@property NSInteger qtm;
@property NSInteger qtmc;
@property NSInteger qtrrqrs;
@property BOOL isLBBB;

- (IBAction)qtInfoButton:(id)sender;
- (IBAction)jtInfoButton:(id)sender;
- (IBAction)qtcInfoButton:(id)sender;
- (IBAction)jtcInfoButton:(id)sender;
- (IBAction)qtmInfoButton:(id)sender;
- (IBAction)qtmcInfoButton:(id)sender;
- (IBAction)qtrrqrsInfoButton:(id)sender;

@end
