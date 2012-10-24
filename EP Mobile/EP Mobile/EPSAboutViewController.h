//
//  EPSAboutViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/29/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSAboutViewController : UIViewController

- (IBAction)doneButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;

@end
