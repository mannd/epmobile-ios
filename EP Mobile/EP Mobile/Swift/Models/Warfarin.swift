//
//  Warfarin.swift
//  EP Mobile
//
//  Created by David Mann on 5/12/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum InrTarget: Int, CaseIterable, Identifiable {
    case low
    case high

    var id: InrTarget { self }

    var description: String {
        switch self {
        case .low:
            return "2.0 to 3.0"
        case .high:
            return "2.5 to 3.5"
        }
    }
}

struct Warfarin {

    let lowInrRange: ClosedRange = 2.0...3.0
    let highInrRange: ClosedRange = 2.5...3.5

    var inr: Double
    var weeklyDose: Double
    var tabletSize: Double

    private let doseRange: ClosedRange<Double>

    init(inr: Double, weeklyDose: Double, tabletSize: Double, inrTarget: InrTarget) {
        self.inr = inr
        self.weeklyDose = weeklyDose
        self.tabletSize = tabletSize
        switch inrTarget {
        case .low:
            doseRange = lowInrRange
        case .high:
            doseRange = highInrRange
        }
    }


    func getDoseChange() -> DoseChange {
        var doseChange = DoseChange()
        if inr > 6.0 {
            doseChange.instruction = .holdWarfarin
        } else if inrIsTherapeutic() {
            doseChange.instruction = .therapeutic
        } else if doseRange == lowInrRange {
            doseChange = getDoseChangeLowInrRange()
        } else if doseRange == highInrRange {
            doseChange = getDoseChangeHighInrRange()
        }
        return doseChange
    }

    func getDoseChangeLowInrRange() -> DoseChange {
        var doseChange = DoseChange()
        if inr > 3.6 {
            doseChange.instruction = .holdOneDose
        }
        if inr < 2.0 {
            doseChange.range = 5...20
            doseChange.direction = .increase
        } else if inr >= 3.0 && inr < 3.6 {
            doseChange.range = 5...15
            doseChange.direction = .decrease
        } else if inr >= 3.6 && inr < 4 {
            doseChange.range = 10...15
            doseChange.direction = .decrease
        } else if inr > 4 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
        }
        return doseChange
    }

    func getDoseChangeHighInrRange() -> DoseChange {
        var doseChange = DoseChange()
        if inr < 2.0 {
            doseChange.range = 10...20
            doseChange.direction = .increase
            doseChange.instruction = .giveAdditionalDose
        } else if inr >= 2.0 && inr < 2.5 {
            doseChange.range = 5...15
            doseChange.direction = .increase
        } else if inr > 3.6 && inr < 4.6 {
            doseChange.range = 5...15
            doseChange.direction = .decrease
        } else if inr >= 4.6 && inr < 5.2 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
            doseChange.instruction = .holdOneDose
        } else if inr > 5.2 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
            doseChange.instruction = .holdTwoDoses
        }
        return doseChange
    }

    func inrIsTherapeutic() -> Bool {
        return doseRange.contains(inr)
    }

    func weeklyDoseIsSane() -> Bool {
        // dose calculator algorithm should handle from about 3 half tabs a week to 2 tabs daily
        return (weeklyDose > (4 * 0.5 * tabletSize)) && (weeklyDose < (2 * tabletSize * 7));
    }

    func getNewDoseFrom(percent: Double,
                        oldDose: Double,
                        doseChangeDirection: DoseChangeDirection) -> Double {
        return round(oldDose + (doseChangeDirection == .increase ? oldDose * percent : -oldDose * percent))
    }
}

enum DoseChangeDirection {
    case increase
    case decrease
}

enum DoseInstruction {
    case giveAdditionalDose
    case holdOneDose
    case holdTwoDoses
    case holdWarfarin
    case therapeutic

    var description: String {
        switch self {
        case .giveAdditionalDose:
            return "Give additional dose."
        case .holdOneDose:
            return "Consider holding one dose."
        case .holdTwoDoses:
            return "Consider holding up to two doses."
        case .holdWarfarin:
            return "Hold warfarin until INR back in therapeutic range."
        case .therapeutic:
            return "INR is therapeutic. No change in warfarin dose."
        }
    }
}

struct DoseChange {
    var range: ClosedRange<Int>? = nil // range of percent change in dose
    var direction: DoseChangeDirection? = nil
    var instruction: DoseInstruction? = nil
}


//    NSString *message = @"";
//    BOOL showDoses = NO;
//    NSString *inrText = [self.inrField text];
//    float inr = [inrText floatValue];
//    NSString *weeklyDoseText = [self.weeklyDoseField text];
//    weeklyDose = [weeklyDoseText floatValue];
//    if (inr <= 0 || weeklyDose <= 0) {
//        message = @"INVALID ENTRY";
//    }
//    else if (inr >= 6.0)
//        message = @"Hold warfarin until INR back in therapeutic range.";
//    else if ([self inrTherapeutic:inr])
//        message = @"INR is therapeutic. No change in warfarin dose.";
//    else {
//        doseChange = [self percentDoseChange:inr];
//        if (doseChange.lowEnd <= 0 || doseChange.highEnd <= 0)
//            message = @"INVALID ENTRY";
//        else {
//            if (doseChange.message != nil)
//                message = [doseChange.message stringByAppendingString:@"\n"];
//            BOOL increaseDose = (doseChange.direction == INCREASE);
//            if (increaseDose)
//                message = [message stringByAppendingString:@"Increase "];
//            else
//                message = [message stringByAppendingString:@"Decrease "];
//            float lowEndDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(doseChange.lowEnd / 100.0) fromOldDose:weeklyDose isIncrease:(increaseDose)];
//            float highEndDose = [EPSWarfarinDailyDoseCalculator getNewDoseFromPercentage:(doseChange.highEnd / 100.0) fromOldDose:weeklyDose isIncrease:(increaseDose)];
//            message = [message stringByAppendingString:@"weekly dose by "];
//            message = [message stringByAppendingFormat:@"%ld%% (%1.1f mg/wk) to %ld%% (%1.1f mg/wk).", (long)doseChange.lowEnd, lowEndDose, (long)doseChange.highEnd, highEndDose];
//            showDoses = [self weeklyDoseIsSane:weeklyDose forTabletSize:[self getTabletSize]];
//
//        }
//    }
//    self.resultLabel.text = message;
//    if (showDoses) {
////        UIActionSheet *actionSheet = [[UIActionSheet alloc]
////                                      initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Show Suggested Daily Doses" otherButtonTitles: nil];
////        [actionSheet showInView:self.view];
//
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {}];
//        UIAlertAction *dailyDoseAction = [UIAlertAction actionWithTitle:@"Show Suggested Daily Doses" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [self performSegueWithIdentifier:@"DosingSegue" sender:nil];
//        }];
//
//        [actionSheet addAction:dailyDoseAction];
//        [actionSheet addAction:defaultAction];
//
//        UIPopoverPresentationController *popPresenter = [actionSheet
//                                                         popoverPresentationController];
//        popPresenter.sourceView = self.calculateButton;
//        popPresenter.sourceRect = self.calculateButton.bounds;
//        [self presentViewController:actionSheet animated:YES completion:nil];
//    }
//}
//
//- (BOOL)weeklyDoseIsSane:(float)dose forTabletSize:(float)size {
//    //return dose - 0.2 * dose >= 7 * 0.5 * tabletSize && dose + 0.2 * dose <= 7 * 2.0 * tabletSize;
//    // dose calculator algorithm should handle from about 3 half tabs a week to 2 tabs daily
//    return (dose > (4 * 0.5 * size)) && (dose < (2 * size * 7));
//}
