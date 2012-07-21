//
//  EPSWarfarinCalculatorViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/20/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDoseChange : NSObject
{
    enum Direction { DECREASE, INCREASE };
}
@property (assign, nonatomic) NSInteger lowEnd;
@property (assign, nonatomic) NSInteger highEnd;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) enum Direction direction;

@end

@interface EPSWarfarinCalculatorViewController : UIViewController
    <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *weeklyDoseField;
@property (strong, nonatomic) IBOutlet UITextField *inrField;

- (IBAction)toggleTabletSize:(id)sender;
- (IBAction)toggleTargetRange:(id)sender;
- (IBAction)calculateButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;


@end

