//
//  IPLabFileOrganizerAppDelegate.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FileEditController;

@interface IPLabFileOrganizerAppDelegate : NSObject {
    NSWindow *window;
	FileEditController *feController;
}

@property (assign) IBOutlet NSWindow *window;
@property(assign)IBOutlet FileEditController *feController;
@end
