//
//  EPSWeightCalculatorNotes.m
//  EP Mobile
//
//  Created by David Mann on 7/3/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSWeightCalculatorNotes.h"

@implementation EPSWeightCalculatorNotes

-(NSString *)noteText {
    return @"Although the package inserts for the drugs included in the drug dose calculators recommend using actual uncorrected body weight and the Cockcroft-Gault formula for Creatinine Clearance, some authorities feel that using a corrected body weight may be more accurate.  This calculator determines the Ideal Body Weight and Adjusted Body Weight from the height, sex, and actual body weight. The Adjusted Body Weight formula here uses a correction factor of 0.4, which may give a more accurate measurement of Creatinine Clearance than other factors.  The formulas are not accurate if the height is less than 60 inches.  Patients who are underweight (weight < Ideal Body Weight) should use actual weight for Creatinine Clearance determination.  Normal weight patients can use Ideal Body Weight, and overweight (defined in this calculator as weight 30% or more over Ideal Body Weight) should use the Adjusted Body Weight.  These weights can be copied to the clipboard and pasted into the drug dose calculator weight fields using the appropriate buttons.  \nReference: Winter MA et al.  Pharmacotherapy 2012;32:604.\nhttp://www.ncbi.nlm.nih.gov/pubmed/22576791";}

-(NSString *)titleText {
    return @"Weight Calculator";
}

-(NSString *)labelText {
    return @"Notes";
}


@end
