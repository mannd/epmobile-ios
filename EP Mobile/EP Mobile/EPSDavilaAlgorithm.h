//
//  EPSDavilaAlgorithm.h
//  EP Mobile
//
//  Created by David Mann on 2/8/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSOutflowVTAlgorithm.h"

@interface EPSDavilaAlgorithm : EPSOutflowVTAlgorithm
// must declare this so modified can inherit it
- (NSString *)getQuestion:(int)step;
- (NSString *)outcomeLocation1:(int)step;
- (NSString *)outcomeLocation2:(int)step;

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *location1;
@property (strong, nonatomic) NSString *location2;

@end
