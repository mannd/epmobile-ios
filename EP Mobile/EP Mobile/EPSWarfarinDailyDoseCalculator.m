//
//  EPSWarfarinDailyDoseCalculator.m
//  EP Mobile
//
//  Created by David Mann on 7/24/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinDailyDoseCalculator.h"

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
    [self zeroDoses:result];    
    // zeros are bad
    if (self.tabletDose == 0 || self.weeklyDose == 0)
        return result;
    // half a tab daily more than weekly dose - bad!
    if (self.tabletDose * 0.5 * NUM_DAYS > self.weeklyDose)
        return result;
    if (self.tabletDose * 2 * NUM_DAYS < self.weeklyDose) // should use bigger tablets
        return result;
    if (self.weeklyDose == self.tabletDose * NUM_DAYS) // just a tablet a day
        for (int i = 0; i < NUM_DAYS; ++i) {
            //result[i] = 1.0;
            [result insertObject:[NSNumber numberWithFloat:1.0] atIndex:i];
        }
    else {
        for (int i = 0; i < NUM_DAYS; ++i) {
            //result[i] = 1.0; // start with a tab a day, no skipping days
            [result insertObject:[NSNumber numberWithFloat:1.0] atIndex:i];
        }
        if (self.tabletDose * NUM_DAYS > self.weeklyDose)
            [self tryDoses:result withOrder:DECREASE_DOSE nextDay:0];
        else if (self.tabletDose * NUM_DAYS < self.weeklyDose)
            [self tryDoses:result withOrder:INCREASE_DOSE nextDay:0];
        else
            // shouldn't happen that they are equal
            return result;
    }
    return result;
}
    
- (NSMutableArray *)tryDoses:(NSMutableArray *)doses withOrder:(enum Order)order nextDay:(int)nextDay {
    // recursive algorithm, finds closest dose (1st >= target)
    if (order == DECREASE_DOSE) {
        while ([self actualWeeklyDose:doses] > self.weeklyDose) {
            // check for all half tablets, we're done
            if ([self allHalfTablets:doses]) {
                [self zeroDoses:doses];
                return doses;
            }
            float value = [[doses objectAtIndex:orderedDays[nextDay]] floatValue];
            if (value > 0.5)
                [doses insertObject:[NSNumber numberWithFloat:(value - 0.5)] atIndex:orderedDays[nextDay]];
            ++nextDay;
            if (nextDay >= NUM_DAYS - 1)
                nextDay = 0;
            [self tryDoses:doses withOrder:order nextDay:nextDay];
        }
        
    }
    if (order == INCREASE_DOSE) {
        while ([self actualWeeklyDose:doses] < self.weeklyDose) {
            // check for all half tablets, we're done
            if ([self allDoubleTablets:doses]) {
                [self zeroDoses:doses];
                return doses;
            }
            float value = [[doses objectAtIndex:orderedDays[nextDay]] floatValue];
            if (value < 2.0)
                [doses insertObject:[NSNumber numberWithFloat:(value + 0.5)] atIndex:orderedDays[nextDay]];
            ++nextDay;
            if (nextDay >= NUM_DAYS - 1)
                nextDay = 0;
            [self tryDoses:doses withOrder:order nextDay:nextDay];
        }
    }
    return doses;
        
}

- (BOOL)allHalfTablets:(NSMutableArray *)doses {
    BOOL allHalfTabs = YES;
    for (int i = 0; i < NUM_DAYS; ++i)
        if ([[doses objectAtIndex:i] floatValue] != 0.5)
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

- (void)zeroDoses:(NSMutableArray *)doses {
for (int i = 0; i < NUM_DAYS; ++i)
    [doses insertObject:[NSNumber numberWithFloat:0.0] atIndex:i];
}

- (float)actualWeeklyDose:(NSMutableArray *)doses {
    float dose = 0;
    for (int i = 0; i < NUM_DAYS; ++i) {
        dose = dose + ([[doses objectAtIndex:i] floatValue] * self.tabletDose);
    }
    return dose;
}



@end
