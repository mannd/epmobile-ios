//
//  EPSSharedMethods.m
//  EP Mobile
//
//  Created by David Mann on 9/24/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSSharedMethods.h"

@implementation EPSSharedMethods


+ (NSString *)trimmedZerosFromNumber:(double) value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    return [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

@end
