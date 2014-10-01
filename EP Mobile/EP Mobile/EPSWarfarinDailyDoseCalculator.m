//
//  EPSWarfarinDailyDoseCalculator.m
//  EP Mobile
//
//  Created by David Mann on 7/24/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinDailyDoseCalculator.h"
#import "EPSLogging.h"

#define NUM_DAYS 7
#define SUN 0
#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6

@implementation EPSWarfarinDailyDoseCalculator
@synthesize tabletDose=tabletDose_;
@synthesize weeklyDose=weeklyDose_;

static int orderedDays[] = { MON, FRI, WED, SAT, TUE, THU, SUN };

- (id)initWithTabletDose:(float)tabletDose andWeeklyDose:(float)weeklyDose {
    self = [super init];
    if (self) {
        self.tabletDose = tabletDose;
        self.weeklyDose = weeklyDose;
    }
    return self;
}

+ (float)getNewDoseFromPercentage:(float)percent fromOldDose:(float)oldDose isIncrease:(BOOL)increase {
    return roundf(oldDose + (increase ? oldDose * percent : -oldDose * percent));
}

- (NSMutableArray *)weeklyDoses {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_DAYS; ++i) {
        //result[i] = 1.0;
        [result insertObject:[NSNumber numberWithFloat:1.0] atIndex:i];
    }
    if (self.weeklyDose == self.tabletDose * NUM_DAYS) // just a tablet a day
        return result;  // done!
    if (self.tabletDose * NUM_DAYS > self.weeklyDose)
        [self tryDoses:result withOrder:DECREASE_DOSE nextDay:0];
    else // must be less than week dose
        [self tryDoses:result withOrder:INCREASE_DOSE nextDay:0];
    return result;
}
    
- (void)tryDoses:(NSMutableArray *)doses withOrder:(enum Order)order nextDay:(int)nextDay {
    // recursive algorithm, finds closest dose (1st >= target)
    BOOL allowZeroDoses = NO;
    if (order == DECREASE_DOSE) {
        while ([self actualWeeklyDose:doses] > self.weeklyDose) {
            // check for all half tablets, can start using zero doses
            if ([self allHalfTablets:doses]) {
                EPSLog(@"All Half Doses!");
                allowZeroDoses = YES;
            }
            float value = [[doses objectAtIndex:orderedDays[nextDay]] floatValue];
            if ((allowZeroDoses && value > 0.0) || value > 0.5)
                [doses replaceObjectAtIndex:orderedDays[nextDay] withObject:[NSNumber numberWithFloat:(value - 0.5)]];
            EPSLog(@"Value = %f, nextDay = %d, orderedDay = %d", value, nextDay, orderedDays[nextDay]);
            EPSLog(@"actualWeeklyDose = %f, target weeklyDose = %f", [self actualWeeklyDose:doses], self.weeklyDose);
            ++nextDay;
            if (nextDay > NUM_DAYS - 1)
                nextDay = 0;
            [self tryDoses:doses withOrder:order nextDay:nextDay];
        }
        
    }
    if (order == INCREASE_DOSE) {
        while ([self actualWeeklyDose:doses] < self.weeklyDose) {
            // check for all double tablets, we're done
            if ([self allDoubleTablets:doses]) {
               return;
            }
            float value = [[doses objectAtIndex:orderedDays[nextDay]] floatValue];
            if (value < 2.0)
                [doses replaceObjectAtIndex:orderedDays[nextDay] withObject:[NSNumber numberWithFloat:(value + 0.5)]];
            EPSLog(@"Value = %f, nextDay = %d, orderedDay = %d", value, nextDay, orderedDays[nextDay]);
            EPSLog(@"actualWeeklyDose = %f, target weeklyDose = %f", [self actualWeeklyDose:doses], self.weeklyDose);
            ++nextDay;
            if (nextDay > NUM_DAYS - 1)
                nextDay = 0;
            [self tryDoses:doses withOrder:order nextDay:nextDay];
        }
    }
    return;
        
}

- (BOOL)allHalfTablets:(NSMutableArray *)doses {
    // actually now checks for all half tabs or zero tabs
    BOOL allHalfTabs = YES;
    for (int i = 0; i < NUM_DAYS; ++i)
        if ([[doses objectAtIndex:i] floatValue] > 0.5)
            allHalfTabs = NO;
    return allHalfTabs;
}

- (BOOL)allDoubleTablets:(NSMutableArray *)doses {
    BOOL allDoubleTabs = YES;
    for (int i = 0; i < NUM_DAYS; ++i)
        if ([[doses objectAtIndex:i] floatValue] != 2.0)
            allDoubleTabs = NO;
    return allDoubleTabs;
}

- (float)actualWeeklyDose:(NSMutableArray *)doses {
    float dose = 0;
    for (int i = 0; i < NUM_DAYS; ++i) {
        dose = dose + ([[doses objectAtIndex:i] floatValue] * self.tabletDose);
    }
    return dose;
}



@end
