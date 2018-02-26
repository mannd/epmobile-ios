//
//  EPSCMSModel.h
//  EP Mobile
//
//  Created by David Mann on 2/22/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSCMSModel : NSObject

typedef NS_ENUM(NSInteger, EF) {
    EFMoreThan35,
    EFFrom30To35,
    EFLessThan30,
    EFNA
};

typedef NS_ENUM(NSInteger, Nyha){
    NyhaI,
    NyhaII,
    NyhaIII,
    NyhaIV,
    NyhaNA
};

typedef NS_ENUM(NSInteger, Indication) {
    Primary,
    Secondary,
    Other,
    IndicationNone
};

typedef NS_ENUM(NSInteger, Approval) {
    Approved,
    NotApproved,
    ApprovalUnclear
};

typedef NS_ENUM(NSInteger, Details) {
    AbsoluteExclusion,
    NoIndications,
    NoEF,
    NoNyha,
    WaitingPeriodException,
    NeedsWaitingPeriod,
    CandidateForRevasc,
    ForgotIcm,
    ForgotMI,
    BridgeToTransplant,
    DetailsNone
};

struct Result {
    Indication indication;
    Approval approval;
    Details details;
    BOOL needsSdmEncounter;
};

@property(assign, nonatomic) BOOL susVT;
@property(assign, nonatomic) BOOL cardiacArrest;
@property(assign, nonatomic) BOOL priorMI;
@property(assign, nonatomic) BOOL icm;
@property(assign, nonatomic) BOOL nicm;
@property(assign, nonatomic) BOOL highRiskCondition;
@property(assign, nonatomic) BOOL icdAtEri;
@property(assign, nonatomic) BOOL transplantList;
@property(assign, nonatomic) EF ef;
@property(assign, nonatomic) Nyha nyha;
@property(assign, nonatomic) BOOL cabgWithin3Months;
@property(assign, nonatomic) BOOL miWithin40Days;
@property(assign, nonatomic) BOOL candidateForRevasc;
@property(assign, nonatomic) BOOL cardiogenicShock;
@property(assign, nonatomic) BOOL nonCardiacDisease;
@property(assign, nonatomic) BOOL brainDamage;
@property(assign, nonatomic) BOOL uncontrolledSvt;

- (id)init;
- (struct Result)getResult;

@end

