//
//  EPSRiskScore.h
//  EP Mobile
//
//  Created by David Mann on 7/28/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EPSRiskScore <NSObject>
- (NSString *)title;
- (NSArray *)riskArray;
- (void)calculateResult;
- (NSString *)riskResult;
- (NSString *)scoreName;
- (NSString *)titleForHeaderSection;
- (NSString *)offset;
@end
