//
//  FileEditController.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileEditController.h"
#import "FileModel.h"

@implementation FileEditController
@synthesize folderExists, fileModel;

- (void)controlTextDidEndEditing:(NSNotification *)aNotification 
{
	NSString *sDir = [[aNotification object] stringValue];
	self.folderExists = [fileModel.fileManager fileExistsAtPath:sDir];
	if (self.folderExists) 
	{
		[startButton setEnabled:YES];
	}
	else 
	{
		[errorForFolder setStringValue:@"error"];
	}
}


- (void)awakeFromNib 
{
	NSLog(@"awake from nib");
	
}

- (id)init 
{
	if (self = [super init]) {
		self.folderExists = NO;
		self.fileModel = [[FileModel alloc] init];
		NSLog(@"init");
	}
	return self;
}

@end