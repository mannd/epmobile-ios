//
//  EPSBrugadaNotesViewController.h
//  EP Mobile
//
//  Created by David Mann on 7/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSBrugadaNotesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;

- (IBAction)doneButtonPressed:(id)sender;



@end
