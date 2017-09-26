//
//  EPSSharedMethods.h
//  EP Mobile
//
//  Created by David Mann on 9/24/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSharedMethods : NSObject

+ (void)showDialogWithTitle:(NSString *)title andMessage:(NSString *)message inView:(UIViewController *)view;
+ (void)showRiskDialogWithMessage:(NSString *)message riskResult:(NSString *)result reference:(NSString *)reference url:(NSURL *)link inView:(UIViewController *)view;
@end
