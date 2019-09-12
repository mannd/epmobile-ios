//
//  EPSCMSViewModel.m
//  EP Mobile
//
//  Created by David Mann on 2/22/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import "EPSCMSViewModel.h"
#import "EPSCMSStrings.h"

@implementation EPSCMSViewModel
{
    NSDictionary *indications;
    NSDictionary *approvals;
    NSDictionary *details;
    EPSCMSModel* model;
}

- (id)initWithSusVT:(BOOL)susVT cardiacArrest:(BOOL)cardiacArrest
            priorMI:(BOOL)priorMI icm:(BOOL)icm nicm:(BOOL)nicm
  highRiskCondition:(BOOL)highRiskCondition icdAtEri:(BOOL)icdAtEri
     transplantList:(BOOL)transplantList ef:(EF)ef
               nyha:(Nyha)nyha cabgWithin3Months:(BOOL)cabgWithin3Months
     miWithin40Days:(BOOL)miWithin40Days candidateForRevasc:(BOOL)candidateForRevasc
   cardiogenicShock:(BOOL)cardiogenicShock nonCardiacDisease:(BOOL)nonCardiacDisease
        brainDamage:(BOOL)brainDamage uncontrolledSvt:(BOOL)uncontrolledSvt {
    self = [super init];
    if (self) {
        model = [[EPSCMSModel alloc] init];
        model.susVT = susVT;
        model.cardiacArrest = cardiacArrest;
        model.priorMI = priorMI;
        model.icm = icm;
        model.nicm = nicm;
        model.highRiskCondition = highRiskCondition;
        model.icdAtEri = icdAtEri;
        model.transplantList = transplantList;
        model.ef = ef;
        model.nyha = nyha;
        model.cabgWithin3Months = cabgWithin3Months;
        model.miWithin40Days =miWithin40Days;
        model.candidateForRevasc = candidateForRevasc;
        model.cardiogenicShock = cardiogenicShock;
        model.nonCardiacDisease = nonCardiacDisease;
        model.brainDamage = brainDamage;
        model.uncontrolledSvt = uncontrolledSvt;
        [self getCMSStrings];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        model = [[EPSCMSModel alloc] init];
        [self getCMSStrings];
    }
    return self;
}

- (void)getCMSStrings {
    indications = [EPSCMSStrings getCMSIndicationStrings];
    approvals = [EPSCMSStrings getCMSApprovalStrings];
    details = [EPSCMSStrings getCMSDetailsStrings];
}

- (NSString *)getMessageFromResult:(struct Result)result {
    NSString *message = @"";
    
    NSString *indicationString = [indications objectForKey:[NSNumber numberWithInt:(int)result.indication]];
    if (indicationString != nil) {
        message = [message stringByAppendingString:indicationString];
    }
    NSString *approvalString = [approvals objectForKey:[NSNumber numberWithInt:(int)result.approval]];
    if (approvalString != nil) {
        message = [message stringByAppendingString:@"\n"];
        message = [message stringByAppendingString:approvalString];
    }
    NSString *detailsString = [details objectForKey:[NSNumber numberWithInt:(int)result.details]];
    if (detailsString != nil) {
        message = [message stringByAppendingString:@"\n"];
        message = [message stringByAppendingString:detailsString];
    }
    return message;
}

- (NSString *)getMessage {
    struct Result result = [model getResult];
    return [self getMessageFromResult:result];
}

@end
