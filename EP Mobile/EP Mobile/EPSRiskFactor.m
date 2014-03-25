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
@synthesize isMajor=isMajor_;
@synthesize sectionNumber=sectionNumber_;

- (id)initWith:(NSString *)name withValue:(NSInteger)value {
    self = [super init];
    if (self) {
        self.name = name;
        self.points = value;
        self.details = @"";
        self.selected = NO;
    }
    return self;
}

- (id)initWithDetails:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *) details {
    self = [self initWith:name withValue:value];
    if (self)
        self.details = details;
    return self;
}

- (id)initWithAllFields:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *)details withIsMajor:(BOOL)isMajor withSectionNumber:(NSUInteger) sectionNumber {
    self = [self initWithDetails:name withValue:value withDetails:details];
    if (self) {
        self.isMajor = isMajor;
        self.sectionNumber = sectionNumber;
    }
    return self;
}




- (void)setName:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *)details {
    self.name = name;
    self.points = value;
    self.details = details;

}

@end
