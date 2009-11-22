//
//  FileEditController.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FileModel;


@interface FileEditController : NSObject {
	IBOutlet NSTextField *sourceFolder;
	IBOutlet NSTextField *steps;
	IBOutlet NSTextField *errorForFolder;
	IBOutlet NSButton *startButton;
	BOOL folderExists;
	FileModel *fileModel;
}
@property(assign)BOOL folderExists;
@property(assign)FileModel *fileModel;
@end
