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
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isMajor;
@property (assign, nonatomic) NSUInteger sectionNumber;

- (id)initWith:(NSString *)name withValue:(NSInteger)value;
- (id)initWithDetails:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *)details;
- (id)initWithAllFields:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *)details withIsMajor:(BOOL)isMajor withSectionNumber:(NSUInteger) sectionNumber;
- (void)setName:(NSString *)name withValue:(NSInteger)value withDetails:(NSString *)details;
- (id)initWithDetailsOnly:(NSString *)name withValue:(NSInteger)value;

@end
