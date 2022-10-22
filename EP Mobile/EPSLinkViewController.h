//
//  EPSLinkViewViewController.h
//  EP Mobile
//
//  Created by David Mann on 3/23/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>

@interface EPSLinkViewController : UIViewController
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString *webPage;
@property (strong, nonatomic) NSString *linkTitle;
@property (strong, nonatomic) UILabel *resultLabel;
@property (strong, nonatomic) NSArray *references;
@property BOOL showToolbar;

@end
