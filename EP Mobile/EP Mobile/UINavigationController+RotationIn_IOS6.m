//
//  UINavigationController+RotationIn_IOS6.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "UINavigationController+RotationIn_IOS6.h"

@implementation UINavigationController (RotationIn_IOS6)
-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
   
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
    
}

@end
