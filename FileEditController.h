//
//  FileEditController.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FileModel;
@class AlertMessage;


@interface FileEditController : NSObject {
	IBOutlet NSTextField *sourceFolder;
	IBOutlet NSTextField *steps;
	IBOutlet NSButton *startButton;
	BOOL folderExists;
	FileModel *fileModel;
	AlertMessage *alert;
}
@property(assign)BOOL folderExists;
@property(assign)FileModel *fileModel;
@property(assign)AlertMessage *alert;

- (IBAction)startProcessing:(id)sender;
- (IBAction)cancelProcessing:(id)sender;
@end
