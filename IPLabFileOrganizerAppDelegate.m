//
//  IPLabFileOrganizerAppDelegate.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IPLabFileOrganizerAppDelegate.h"
#import "FileEditController.h"

@implementation IPLabFileOrganizerAppDelegate

@synthesize window;
@synthesize feController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[feController cancelProcessing:nil];
}

@end
