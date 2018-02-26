//
//  EPSCMSModel.m
//  EP Mobile
//
//  Created by David Mann on 2/22/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import "EPSCMSModel.h"

@interface EPSCMSModel()
@end


@implementation EPSCMSModel

- (id)init {
    self = [super init];
    if (self) {
        _ef = EFNA;
        _nyha = NyhaNA;
    }
    return self;
}

- (struct Result)getResult {
    struct Result result;
    result.indication = IndicationNone;
    result.approval = NotApproved;
    result.details = DetailsNone;
    result.needsSdmEncounter = NO;
    if ([self absoluteExclusion]) {
        result.approval = NotApproved;
        result.details = AbsoluteExclusion;
    }
    else if ([self noIndications]) {
        result.approval = NotApproved;
        result.details = NoIndications;
    }
    else if ([self noEF]) {
        result.approval = NotApproved;
        result.details = NoEF;
    }
    else if ([self secondaryPrevention]) {
        result.details = DetailsNone;
        result.approval = Approved;
        result.indication = Secondary;
    }
    else if (self.highRiskCondition) {
        result.details = DetailsNone;
        result.approval = Approved;
        result.indication = Primary;
        result.needsSdmEncounter = true;
    }
    else if (self.icdAtEri) {
        if ([self waitingPeriod]) {
            result.details = WaitingPeriodException;
        }
        result.approval = Approved;
        result.indication = Other;
    }
    else if ([self primaryPrevention] && [self noNyha]) {
        result.approval = ApprovalUnclear;
        result.indication = Primary;
        result.details = NoNyha;
    }
    else if ([self madit2Indication] || [self scdHeftIndication]) {
        result.indication = Primary;
        result.details = [self getExclusionDetails];
        result.needsSdmEncounter = ![self temporaryExclusion];
        result.approval = [self temporaryExclusion] ? NotApproved : Approved;
    }
    else if ([self forgotIcm]) {
        result.approval = NotApproved;
        result.indication = Primary;
        result.details = ForgotIcm;
    }
    else if ([self forgotMI]) {
        result.approval = NotApproved;
        result.indication = Primary;
        result.details = ForgotMI;
    }
    else if (self.transplantList) {
        result.approval = ApprovalUnclear;
        result.indication = Other;
        result.details = BridgeToTransplant;
    }
    else {
        result.indication = Primary;
        result.approval = NotApproved;
    }
    return result;
    
}
- (BOOL) madit2Indication {
    return self.ef == EFLessThan30 && self.priorMI && self.nyha != NyhaIV;
}

- (BOOL) scdHeftIndication {
    return (self.ef == EFLessThan30 || self.ef == EFFrom30To35)
    && (self.icm || self.nicm)
    && (self.nyha == NyhaII || self.nyha == NyhaIII);
}

- (BOOL) forgotIcm {
    return self.ef == EFFrom30To35
    && !(self.icm || self.nicm)
    && self.priorMI
    && (self.nyha == NyhaII || self.nyha == NyhaIII);
}

- (BOOL) forgotMI {
    return self.icm && !self.priorMI && self.nyha == NyhaI && self.ef == EFLessThan30;
}

- (Details) getExclusionDetails {
    if (self.candidateForRevasc) {
        return CandidateForRevasc;
    }
    else if ([self waitingPeriod]) {
        return NeedsWaitingPeriod;
    }
    else {
        return DetailsNone;
    }
}

- (BOOL)absoluteExclusion {
    return self.cardiogenicShock || self.brainDamage
    || self.nonCardiacDisease || self.uncontrolledSvt;
}

- (BOOL)noIndications {
    return !([self secondaryPrevention]
             || [self primaryPrevention]
             || [self otherIndication]);
}

- (BOOL) secondaryPrevention {
    return self.cardiacArrest || self.susVT;
}

- (BOOL) primaryPrevention {
    return self.priorMI || self.icm || self.nicm || self.highRiskCondition;
}

- (BOOL) otherIndication {
    return self.icdAtEri || self.transplantList;
}

- (BOOL) temporaryExclusion {
    return [self waitingPeriod] || self.candidateForRevasc;
}

- (BOOL) waitingPeriod {
    return self.miWithin40Days || self.cabgWithin3Months;
}

- (BOOL) noEF {
    return self.ef == EFNA;
}

- (BOOL) noNyha {
    return self.nyha == NyhaNA;
}

@end

