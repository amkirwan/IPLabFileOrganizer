//
//  MoveRenameOperation.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileModel.h"


@interface MoveRenameOperation : NSOperation 
{
	FileModel *fileModel;
}
@property(assign) FileModel *fileModel;

- (id)initWithFileModel:(FileModel *)model;
- (void)main;
@end
