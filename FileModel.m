//
//  FileModel.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileModel.h"
#import "MoveRenameOperation.h"

static NSString *OutputFolderName = @"processedIPLab";

@implementation FileModel

@synthesize sourceFolder; 
@synthesize steps;
@synthesize fileManager;
@synthesize delegate;
@synthesize isProcessing;
@synthesize subFoldersPaths;
@synthesize fileNames;
@synthesize createdFolders;
@synthesize completedSteps;

// CLASS METHODS
+ (BOOL)folderExists:(NSString *)dir {
	NSString *path = [dir stringByExpandingTildeInPath];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


// INSTANCE METHODS
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
		return [self createDirectory:OutputFolderName];
	}
	else 
	{
		return NO;
	}

}

- (BOOL)createSubFolders:(NSUInteger) loopSteps {
	if ([fileManager changeCurrentDirectoryPath:
		[self.sourceFolder stringByAppendingPathComponent:OutputFolderName]]) 
	{
		for(int i=0; i < loopSteps; i++)
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

- (void)cancelAll
{
	NSLog(@"cancelAll");
	self.isProcessing = NO;
	[queue cancelAllOperations];
}


- (void)moveFiles
{	
	NSLog(@"moveFiles");
	self.isProcessing = YES; 
	NSMutableArray *allFilesArray = [NSMutableArray arrayWithCapacity:10000];
	
	NSLog(@"%@", self.subFoldersPaths);
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
				[allFilesArray addObject:[dir stringByAppendingPathComponent:file]];
			}
		}
			files = nil;
	}
	[self createProcessedFolder];
	[self createSubFolders:self.steps];
	
	NSUInteger incr = 1;
	NSString *newFilename;
	for(NSUInteger i=0; self.isProcessing && i < self.steps; i++)
	{
		NSString *destPath = [self.sourceFolder 
								stringByAppendingPathComponent:[OutputFolderName stringByAppendingPathComponent:
								[NSString stringWithFormat:@"%lu", (unsigned long)(i + incr)]]];
		NSUInteger indexName = 1;
		for(NSUInteger j=i; j < [allFilesArray count]; j += self.steps)
		{
			if (!self.isProcessing) break;			
			if (indexName < 10) 
			{
				newFilename = [@"a000" stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)indexName]];
				//NSLog(@"%@", newFilename);
			}
			else if (indexName >= 10 && indexName < 100)
			{
				newFilename = [@"a00" stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)indexName]];
			}
			else if (indexName >= 100 && indexName < 1000)
			{
				newFilename = [@"a0" stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)indexName]];
			}
			else
			{
				newFilename = [@"a" stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)indexName]];
			}
			NSString *oldPath = [allFilesArray objectAtIndex:j];
			NSString *newPath = [destPath stringByAppendingPathComponent:newFilename];
			//NSLog(@"oldPath= %@", oldPath);
			//NSLog(@"newPath= %@", newPath);
			NSError *error = nil;
			BOOL move = [self.fileManager moveItemAtPath:oldPath toPath:newPath error:&error];
			if (!move)
			{
				NSLog(@"%@", [error localizedFailureReason]);
			}
			indexName++;
		}
		[self.delegate performSelectorOnMainThread:@selector(updateProgress:) 
										withObject:[NSNumber numberWithUnsignedInteger:(i + incr)]
										waitUntilDone:YES];
	}	
	allFilesArray = nil;
	NSString *message;
	if (self.isProcessing) 
	{
		message = @"Completed processing files into directory processedIPLab.";
		self.isProcessing = NO;
	}
	else
	{
		message = @"Processing cancelled!";
	}
		
	[self.delegate performSelectorOnMainThread:@selector(finishedProcessing:) 
									withObject:message
								 waitUntilDone:NO];
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
	
	// remove objects
	[fullPaths removeObjectsInArray:removeArray];	
	if ([fullPaths count] == 0) 
	{
		[fullPaths addObject:self.sourceFolder];
	}
	[removeArray removeAllObjects];
	removeArray = nil;
	return fullPaths;
}

- (void)startProcessingFromDir:(NSString *)sDir steps:(NSString *)sSteps
{
	self.sourceFolder = sDir;
		
	self.steps = (NSUInteger)[sSteps integerValue];
	if ([fileManager changeCurrentDirectoryPath:self.sourceFolder]) 
	{	
		NSString *message;
		message = [[NSString stringWithString:@"The folder '"] stringByAppendingString:OutputFolderName];
		message = [message stringByAppendingString:@"' alread exists.\n Please delete or move to continue processing."];
		//NSLog(@"%@", message);
		if([fileManager fileExistsAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:OutputFolderName]])
		{
			[self.delegate performSelectorOnMainThread:@selector(finishedProcessing:) 
											withObject:message
										 waitUntilDone:NO];
		}
		else 
		{			
			self.subFoldersPaths = [self getSubFolderPaths];
			queue = [[NSOperationQueue alloc] init];
			MoveRenameOperation *op = [[MoveRenameOperation alloc] init];
			[op setFileModel:self];
			[queue addOperation:op];	
		}

	}
	
}

- (id)init
{
	if (self = [super init]) 
	{	
		self.sourceFolder = nil;
		self.steps = 1;
		self.fileManager = [[NSFileManager alloc] init];
	}
	return self;
}
@end
