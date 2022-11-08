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

+ (void)showRiskDialogWithMessage:(NSString *)message riskResult:(NSString *)result inView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Risk Score" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {}];
    UIAlertAction *copyResultAction = [UIAlertAction actionWithTitle:@"Copy Result" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
    }];

    [alert addAction:copyResultAction];
    [alert addAction:defaultAction];
    
    [view presentViewController:alert animated:YES completion:nil];
}

+ (void)showCopyResultDialogWithMessage:(NSString *)message copiedResult:(NSString *)result title:(NSString *)title inView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {}];
    UIAlertAction *copyResultAction = [UIAlertAction actionWithTitle:@"Copy Result" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
        [EPSSharedMethods showDialogWithTitle:@"Result Copied" andMessage:@"Result copied to clipboard." inView:view];
    }];

    [alert addAction:copyResultAction];
    [alert addAction:defaultAction];

    [view presentViewController:alert animated:YES completion:nil];
}


+ (NSString *)trimmedZerosFromNumber:(double) value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    return [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

@end
