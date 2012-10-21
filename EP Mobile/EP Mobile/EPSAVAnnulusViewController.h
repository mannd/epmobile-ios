//
//  EPSAVAnnulusViewController.h
//  EP Mobile
//
//  Created by David Mann on 8/7/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSAVAnnulusViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) IBOutlet UIImageView *asapImageView;
@property (strong, nonatomic) IBOutlet UIImageView *epicardialapImageView;
@property (strong, nonatomic) IBOutlet UIImageView *lalapImageView;
@property (strong, nonatomic) IBOutlet UIImageView *llapImageView;

@property (strong, nonatomic) IBOutlet UILabel *mapLocationLabel;

@property BOOL showPathway;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *location1;
@property (strong, nonatomic) NSString *location2;


@end
