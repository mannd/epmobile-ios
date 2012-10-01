//
//  EPSNotesProtocol.h
//  EP Mobile
//
//  Created by David Mann on 10/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EPSNotesProtocol <NSObject>
- (NSString *)noteText;
- (NSString *)titleText;
- (NSString *)labelText;
@end
