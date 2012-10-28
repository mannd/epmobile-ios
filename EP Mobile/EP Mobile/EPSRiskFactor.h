//
//  EPSRiskFactor.h
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSRiskFactor : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger points;
@property (strong, nonatomic) NSString *details;
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL isMajor;
@property (assign, nonatomic) NSUInteger sectionNumber;

- (id)initWith:(NSString *)name withValue:(int)value;
- (id)initWithDetails:(NSString *)name withValue:(int)value withDetails:(NSString *)details;
- (id)initWithAllFields:(NSString *)name withValue:(int)value withDetails:(NSString *)details withIsMajor:(BOOL)isMajor withSectionNumber:(NSUInteger) sectionNumber;
- (void)setName:(NSString *)name withValue:(int)value withDetails:(NSString *)details;

@end
