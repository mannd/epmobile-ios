//
//  EPSWarfarinDailyDoseCalculator.h
//  EP Mobile
//
//  Created by David Mann on 7/24/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSWarfarinDailyDoseCalculator : NSObject
{
    enum Order { INCREASE_DOSE, DECREASE_DOSE };
}
@property (assign, nonatomic) float tabletDose, weeklyDose;

+ (float)getNewDoseFromPercentage:(float)percent fromOldDose:(float)oldDose isIncrease:(BOOL)increase;

- (id)initWithTabletDose:(float)tabletDose andWeeklyDose:(float)weeklyDose;
- (NSMutableArray *)weeklyDoses;
- (NSMutableArray *)tryDoses:(NSArray *)doses withOrder:(enum Order)order nextDay:(int)next;
- (float)actualWeeklyDose:(NSArray *)doses;

@end
