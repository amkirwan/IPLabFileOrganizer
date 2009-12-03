//
//  FileModel.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressIndicatorDelegate.h"
@class MoveRenameOperation;

@interface FileModel : NSObject {
	NSString *sourceFolder;
	NSUInteger steps;
	NSObject <ProgressIndicatorDelegate> *delegate;
	NSOperationQueue *queue;
	NSFileManager *fileManager;
	BOOL isProcessing;
}
@property(copy)NSString *sourceFolder;
@property(assign)NSUInteger steps;
@property(assign)NSUInteger completedSteps;
@property(assign)id delegate;
@property(assign)NSFileManager *fileManager;
@property(assign)BOOL isProcessing;
@property(assign)NSMutableArray *createdFolders;
@property(retain)NSArray *subFoldersPaths;
@property(assign)NSArray *fileNames;


+ (BOOL)folderExists:(NSString *)dir;

- (void)startProcessingFromDir:(NSString *)sDir steps:(NSString *)sSteps;
- (void)moveFiles;
- (void)cancelAll;
@end
