//
//  EPSArrudaAlgorithm.h
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSOutflowVTAlgorithm.h"

@interface EPSArrudaAlgorithm : EPSOutflowVTAlgorithm
// must declare this so modified can inherit it
- (NSString *)getQuestion:(int)step;
- (NSString *)outcomeLocation1:(int)step;
- (NSString *)outcomeLocation2:(int)step;

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *location1;
@property (strong, nonatomic) NSString *location2;

@end
