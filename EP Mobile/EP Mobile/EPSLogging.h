//
//  EPSLogging.h
//  EP Mobile
//
//  Created by David Mann on 9/30/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

#ifndef EP_Mobile_EPSLogging_h
#define EP_Mobile_EPSLogging_h

#ifdef DEBUG
#define EPSLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define EPSLog(...) do { } while (0)
#endif

#endif
