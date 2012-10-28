//
//  EPSNotesViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSNotesViewController : UIViewController
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)doneButtonPressed:(id)sender;



@end
