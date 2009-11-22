//
//  FileEditController.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileEditController.h"
#import "FileModel.h"

@implementation FileEditController

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
	NSLog(@"%@", aNotification);
	[errorForFolder setStringValue:@"error"];
}

- (void)awakeFromNib {
	NSLog(@"awake from nib");
	fileModel = [[FileModel alloc] init];
}

@end
