//
//  WeightCalculatorViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct WeightCalculatorViewModel {
    var model: Weight

    func idealBodyWeight() -> String {
        let ibw = model.idealBodyWeight()
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter = numberFormatter
        return "Ideal Body Weight = \(formatter.string(from: ibw))"
    }
}




//NSString *weightText = self.weightTextField.text;
//    double weight = [weightText doubleValue];
//    NSString *heightText = self.heightTextField.text;
//    double height = [heightText doubleValue];
//    if (weight <= 0.0 || height <= 0.0) {
//        self.resultLabel.text = @"INVALID ENTRY";
//        return;
//    }
//    double weightInPounds = 0;
//    if (weightIsPounds) {
//        EPSLog(@"Weight is in pounds (%f lb)", weight);
//        weightInPounds = weight;
//        weight = [self lbsToKgs:weight];
//        EPSLog(@"Converted weight in kgs is %f", weight);
//    }
//    if (! heightIsInches) {
//        height = [self cmsToIns:height];
//    }
//    BOOL isMale = ([self.sexSegmentedControl selectedSegmentIndex] == 0);
//    calculatedIbw = [self idealBodyWeightForHeight:height forIsMale:isMale];
//    calculatedAbw = [self adjustedBodyWeight:calculatedIbw forActualWeight:weight];
//    if (weightIsPounds) {
//        calculatedIbw = [self kgsToLbs:calculatedIbw];
//        calculatedAbw = [self kgsToLbs:calculatedAbw];
//        // change actual weight back to pounds for determining overweight and underweight
//        weight = weightInPounds;
//    }
//    NSString *formattedIbw = [NSString stringWithFormat:@"%.1f", calculatedIbw];
//    NSString *formattedAbw = [NSString stringWithFormat:@"%.1f", calculatedAbw];
//    NSString *formattedWeight = [NSString stringWithFormat:@"%.1f", weight];
//    // these are the string pasted to the clipboard
//    roundedIbw = formattedIbw;
//    roundedAbw = formattedAbw;
//
//    if (weightIsPounds) {
//        formattedIbw = [formattedIbw stringByAppendingString:@" lbs"];
//        formattedAbw = [formattedAbw stringByAppendingString:@" lbs"];
//        formattedWeight = [formattedWeight stringByAppendingString:@" lbs"];
//    }
//    else {
//        formattedIbw = [formattedIbw stringByAppendingString:@" kgs"];
//        formattedAbw = [formattedAbw stringByAppendingString:@" kgs"];
//        formattedWeight = [formattedWeight stringByAppendingString:@" kgs"];
//
//    }
//
//    NSString *result = @"";
//    result = [result stringByAppendingString:[NSString stringWithFormat:@"Ideal Body Weight = %@\nAdjusted Body Weight = %@", formattedIbw, formattedAbw]];
//    if ([self isUnderHeight:height])
//        result = [result stringByAppendingString:@"\nThese measurements might not be useful when height < 60 inches."];
//    else if ([self isOverweight:calculatedIbw forActualWeight:weight])
//        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Adjusted Body Weight (%@)", formattedAbw]];
//    else if ([self isUnderWeight:weight forIbw:calculatedIbw])
//        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Actual Body Weight (%@)", formattedWeight]];
//    else // normal weight
//        result = [result stringByAppendingString:[NSString stringWithFormat:@"\nRecommended Weight = Ideal Body Weight (%@)", formattedIbw]];
//    self.resultLabel.text = result;
//}
//
