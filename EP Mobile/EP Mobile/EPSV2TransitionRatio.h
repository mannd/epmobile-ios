//
//  EPSV2TransitionRatio.h
//  EP Mobile
//
//  Created by David Mann on 5/25/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSStepAlgorithmProtocol.h"
#define SPECIAL_STEP_2 888

NS_ASSUME_NONNULL_BEGIN
@interface EPSV2TransitionRatio : NSObject <EPSStepAlgorithmProtocol>
- (void)adjustStepsForward:(int)step;
@end

NS_ASSUME_NONNULL_END
