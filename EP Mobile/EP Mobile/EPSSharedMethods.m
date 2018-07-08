//
//  EPSSharedMethods.m
//  EP Mobile
//
//  Created by David Mann on 9/24/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSSharedMethods.h"

@implementation EPSSharedMethods

+ (void)showDialogWithTitle:(NSString *)title andMessage:(NSString *)message inView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [view presentViewController:alert animated:YES completion:nil];
}

+ (void)showRiskDialogWithMessage:(NSString *)message riskResult:(NSString *)result reference:(NSString *)reference url:(NSURL *)url inView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Risk Score" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {}];
    UIAlertAction *copyResultAction = [UIAlertAction actionWithTitle:@"Copy Result" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
    }];
    UIAlertAction *referenceAction = [UIAlertAction actionWithTitle:@"Reference" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showDialogWithTitle:@"Reference" andMessage:reference inView:view];
    }];
    UIAlertAction *linkAction = [UIAlertAction actionWithTitle:@"Link" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [[UIApplication sharedApplication] openURL:url];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

    }];
    
    [alert addAction:copyResultAction];
    [alert addAction:referenceAction];
    [alert addAction:linkAction];
    [alert addAction:defaultAction];
    
    [view presentViewController:alert animated:YES completion:nil];
}

@end
