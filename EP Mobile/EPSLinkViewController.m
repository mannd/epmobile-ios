//
//  EPSLinkViewViewController.m
//  EP Mobile
//
//  Created by David Mann on 3/23/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSLinkViewController.h"

@interface EPSLinkViewController ()

@end

@implementation EPSLinkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView setScalesPageToFit:YES];
    NSString *urlAddress= self.webPage;
    NSURL *url = nil;
    if ([urlAddress hasPrefix:@"http"]) {
        url = [NSURL URLWithString:urlAddress];
    }
    else {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:urlAddress ofType:@"html"] isDirectory:NO];
        [self.webView setScalesPageToFit:NO];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
    if (([self.drugTitle length] > 0)) {
        self.title = self.drugTitle;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
