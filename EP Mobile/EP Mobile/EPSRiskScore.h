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
- (NSString *)getTitleForHeaderSection:(NSInteger)section;
- (int)getOffset:(NSInteger)section;
- (int)numberOfSections;
- (int)numberOfRowsInSection:(NSInteger)section;
- (int)calculateScore:(NSMutableArray *)risks;
- (NSString *)getMessage:(int)score;
- (NSString *)getInstructions;
- (NSString *)getKey;
- (CGFloat)rowHeight:(CGFloat)defaultHeight;
- (void)formatCell:(UITableViewCell *)cell;
- (NSArray *)getReferences;
- (NSArray *)risksSelected:(NSArray *)risks;
- (NSString *)getFullRiskReportFromMessage:(NSString *)message andRisks:(NSArray *)risks;
- (int)detailTextNumberOfLines;
+ (NSString *)formatRisks:(NSArray *)risks;

@property (strong, nonatomic) NSArray *references;

@end
