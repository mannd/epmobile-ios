//
//  EPSLinkViewViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/23/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSLinkViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *webPage;
@property (strong, nonatomic) NSString *linkTitle;
@property (strong, nonatomic) UILabel *resultLabel;
@property BOOL showToolbar;


@end
