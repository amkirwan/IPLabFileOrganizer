//
//  FileModel.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FileModel : NSObject {
	NSString *sourceFolder;
	NSInteger *steps;
	NSFileManager *fileManager;
}
@property(copy)NSString *sourceFolder;
@property(assign)NSInteger *steps;
@property(assign)NSFileManager *fileManager;
@property(copy)NSString *outputFolderName;
@property(assign)BOOL continueProcessing;
@property(assign)NSArray *subFoldersPaths;
@property(assign)NSArray *fileNames;

+ (BOOL)folderExists:(NSString *)dir;

- (void)startProcessingFromDir:(NSString *)sDir steps:(NSString *)sSteps;
@end
