//
//  FileModel.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressIndicatorDelegate.h"

@interface FileModel : NSObject {
	NSString *sourceFolder;
	NSUInteger steps;
	NSObject <ProgressIndicatorDelegate> *delegate;
	NSFileManager *fileManager;
}
@property(copy)NSString *sourceFolder;
@property(assign)NSUInteger steps;
@property(assign)NSUInteger completedSteps;
@property(assign)id delegate;
@property(assign)NSFileManager *fileManager;
@property(copy)NSString *outputFolderName;
@property(assign)BOOL continueProcessing;
@property(assign)NSMutableArray *createdFolders;
@property(assign)NSArray *subFoldersPaths;
@property(assign)NSArray *fileNames;


+ (BOOL)folderExists:(NSString *)dir;

- (void)startProcessingFromDir:(NSString *)sDir steps:(NSString *)sSteps;
@end
