//
//  EPSRiskFactor.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSRiskFactor.h"

@implementation EPSRiskFactor
@synthesize name=name_;
@synthesize points=points_;
@synthesize details=details_;
@synthesize selected=selected_;

- (id)initWith:(NSString *)name withValue:(int)value {
    self = [super init];
    if (self) {
        self.name = name;
        self.points = value;
        self.details = @"";
        self.selected = NO;
    }
    return self;
}

- (id)initWithDetails:(NSString *)name withValue:(int)value withDetails:(NSString *) details {
    self = [self initWith:name withValue:value];
    if (self)
        self.details = details;
    return self;
}

@end
