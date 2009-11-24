//
//  FileModel.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel
@synthesize sourceFolder, steps, fileManager, outputFolderName, 
	continueProcessing, subFoldersPaths, fileNames;

+ (BOOL)folderExists:(NSString *)dir {
	NSString *path = [dir stringByExpandingTildeInPath];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)createDirectory:(NSString *)dirName
{
	return [self.fileManager createDirectoryAtPath:dirName 
		   withIntermediateDirectories:NO 
							attributes:nil 
								 error:NULL]; 
}

- (BOOL)createProcessedFolder {
	if([self.sourceFolder isEqualToString:[fileManager currentDirectoryPath]]) 
	{
		return [self createDirectory:self.outputFolderName];
	}
	else 
	{
		return NO;
	}

}

- (BOOL)createSubFolders:(NSString *)loopSteps {
	if ([fileManager changeCurrentDirectoryPath:
		[self.sourceFolder stringByAppendingPathComponent:self.outputFolderName]]) 
	{
		
		int length = [loopSteps intValue];
		for(int i=0; i < length; i++)
		{
			NSString *dirName = [NSString stringWithFormat:@"%d", i+1];
			[self createDirectory:dirName];
		}
		return YES;
	}
	else 
	{
		return NO;
	}

}

- (void)moveFiles
{
	for(NSString *item in self.subFoldersPaths)
	{
		NSLog(@"%@", item);
	}
} 

- (NSMutableArray *)getSubFolderPaths
{
	NSArray *paths = [fileManager contentsOfDirectoryAtPath:self.sourceFolder error:nil];
	NSMutableArray *fullPaths = [NSMutableArray arrayWithCapacity:[paths count]];
	
	for(int i=0; i < [paths count]; i++)
	{
		[fullPaths addObject:[self.sourceFolder stringByAppendingPathComponent:
												[paths objectAtIndex:i]]];
	}
	// remove non-directories
	NSMutableArray *removeArray = [[NSMutableArray alloc] init];
	for(NSString *item in fullPaths)
	{
		NSDictionary *dic = [self.fileManager 
							 attributesOfItemAtPath:item error:NULL];
		if (![@"NSFileTypeDirectory" isEqualToString:[dic valueForKey:@"NSFileType"]])
		{
			[removeArray addObject:item];
		}
	}
	[fullPaths removeObjectsInArray:removeArray];
	[removeArray removeAllObjects];
	removeArray = nil;
	return fullPaths;
}

- (void)startProcessingFromDir:(NSString *)sDir steps:(NSString *)sSteps
{
	self.sourceFolder = sDir;
	self.steps = steps;
	if ([fileManager changeCurrentDirectoryPath:self.sourceFolder]) 
	{
		self.subFoldersPaths = [self getSubFolderPaths];
		[self createProcessedFolder];
		[self createSubFolders:sSteps];
		[self moveFiles];
	}
	
}

- (id)init
{
	if (self = [super init]) {	
		self.sourceFolder = nil;
		self.steps = nil;
		self.outputFolderName = @"processedIPLab";
		self.fileManager = [[NSFileManager alloc] init];
	}
	return self;
}
@end
