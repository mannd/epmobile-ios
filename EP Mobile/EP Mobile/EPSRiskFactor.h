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
@property (strong, nonatomic) NSString *details;
@property (assign, nonatomic) NSInteger value;

@end
