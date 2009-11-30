//
//  ProgressIndicatorDelegate.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@protocol ProgressIndicatorDelegate

@required
- (void) updateProgress:(NSUInteger)completed;

@end
