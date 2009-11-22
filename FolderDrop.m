//
//  FolderDrop.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FolderDrop.h"


@implementation FolderDrop

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self registerForDraggedTypes:[NSArray arrayWithObjects:
									   NSFilenamesPboardType, nil]];
		
		fileThumb = nil;
		fileName = nil;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
	return YES;
}

@end
