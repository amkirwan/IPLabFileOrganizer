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
	continueProcessing, subFoldersPaths, fileNames, createdFolders;

+ (BOOL)folderExists:(NSString *)dir {
	NSString *path = [dir stringByExpandingTildeInPath];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSArray *)sortedArrayOfStringsAsc:(NSArray *)array
{
	NSSortDescriptor *sortAsc = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
	NSArray *sortAscArray = [NSArray arrayWithObject:sortAsc];
	NSArray *sorted = [array sortedArrayUsingDescriptors:sortAscArray];
	sortAsc = nil;
	sortAscArray = nil;
	return sorted;
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
		for(int i=0; i < [loopSteps intValue]; i++)
		{
			NSString *dirName = [NSString stringWithFormat:@"%d", i+1];
			[self.createdFolders addObject:dirName];
			[self createDirectory:dirName];
		}
		return YES;
	}
	else 
	{
		return NO;
	}
}

- (BOOL)assertRegex:(NSString*)stringToSearch withRegex:(NSString*)regexString {
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regex evaluateWithObject:stringToSearch];    
}


- (void)moveFiles
{	
	self.continueProcessing = YES; 
	NSMutableArray *allFilesArray = [NSMutableArray arrayWithCapacity:10000];
	
		// extract filenames to process
		for(NSString *dir in self.subFoldersPaths)
		{
			
			NSArray *files = [self sortedArrayOfStringsAsc:
									[fileManager contentsOfDirectoryAtPath:dir 
																	 error:nil]];
			for(NSString *file in files)
			{
				if (![self assertRegex:file withRegex:@".DS_Store"]) 
				{
					NSLog(@"%@", file);
					[allFilesArray addObject:file];
				}
			}
			files = nil;
		}
	
		while (continueProcessing) 
		{
			for(NSUInteger i=0; i < self.steps; i++)
			{
				NSString *folderName = [self.sourceFolder 
										stringByAppendingPathComponent:
										[NSString stringWithFormat:@"%qu", (i + 1)]];
				NSUInteger indexName = 1;
				for(NSUInteger j=0; j < [allFilesArray count]; j += self.steps)
				{
					NSString *oldPath = [self.sourceFolder stringByAppendingPathComponent:[allFilesArray objectAtIndex:j]];
					NSString *newPath = [folderName stringByAppendingPathComponent:[NSString stringWithFormat:@"%qu", indexName]];
					//NSLog(@"%@", oldPath);
					//NSLog(@"%@", newPath);
					[[NSFileManager defaultManager] movePath:oldPath toPath:newPath handler:nil];
					indexName++;
				}
			}
			self.continueProcessing = NO;
		}	
	allFilesArray = nil;	
} 

- (NSMutableArray *)getSubFolderPaths
{
	NSArray *paths = [fileManager contentsOfDirectoryAtPath:self.sourceFolder error:nil];
	// sort the array
	NSArray *sortedPaths = [self sortedArrayOfStringsAsc:paths];
	paths = nil;
	
	NSMutableArray *fullPaths = [NSMutableArray arrayWithCapacity:[paths count]];
	
	for(NSUInteger i=0; i < [sortedPaths count]; i++)
	{
		[fullPaths addObject:[self.sourceFolder stringByAppendingPathComponent:
												[sortedPaths objectAtIndex:i]]];
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
	self.steps = [sSteps integerValue];
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
		self.steps = 1;
		self.outputFolderName = @"processedIPLab";
		self.fileManager = [[NSFileManager alloc] init];
	}
	return self;
}
@end
