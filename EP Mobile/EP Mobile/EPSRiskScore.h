//
//  EPSRiskScore.h
//  EP Mobile
//
//  Created by David Mann on 8/4/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSRiskScore : NSObject
- (NSString *)getTitle;
- (NSString *)getScoreName;
- (NSMutableArray *)getArray;
- (NSString *)getRisk;
- (NSString *)getTitleForHeaderSection;
- (int)getOffset;
- (int)calculateScore:(NSMutableArray *)risks;
- (NSString *)getResultMessage:(NSMutableArray *)risks;

@end
