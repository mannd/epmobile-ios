//
//  EPSComplexStepAlgorithmProtocol.h
//  EP Mobile
//
//  Created by David Mann on 4/4/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSStepAlgorithmProtocol.h"

@protocol EPSComplexStepAlgorithmProtocol <EPSStepAlgorithmProtocol>
- (NSString *)button4Result:(int *)step;
- (NSString *)button5Result:(int *)step;
- (NSString *)button6Result:(int *)step;
@end
