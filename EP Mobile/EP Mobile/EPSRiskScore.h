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
- (NSString *)getTitleForHeaderSection:(int)section;
- (int)getOffset:(int)section;
- (int)numberOfSections;
- (int)numberOfRowsInSection:(int)section;
- (int)calculateScore:(NSMutableArray *)risks;
- (NSString *)getMessage:(int)score;
- (CGFloat)rowHeight:(CGFloat)defaultHeight;
- (void)formatCell:(UITableViewCell *)cell;

@end
