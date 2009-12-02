//
//  MoveRenameOperation.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MoveRenameOperation.h"
#import "FileModel.h"


@implementation MoveRenameOperation

@synthesize fileModel;

- (void)main
{
	if(self.isCancelled) return;
	[self.fileModel moveFiles];
}

- (id)initWithFileModel:(FileModel *)model
{
	if (self = [super init]) 
	{
		self.fileModel = model;
	}
	return self;
}

- (id)init
{
	return [self initWithFileModel:nil];
}

@end
