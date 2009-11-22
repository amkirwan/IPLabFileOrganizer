//
//  FileModel.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileModel.h"


@implementation FileModel
@synthesize sourceFolder, steps, fileManager;

- (id)init
{
	if (self = [super init]) {	
		self.sourceFolder = nil;
		self.steps = nil;
		self.fileManager = [NSFileManager defaultManager];
	}
	return self;
}
@end
