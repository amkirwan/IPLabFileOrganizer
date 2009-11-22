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
	NSNumber *steps;
}
@property(copy)NSString *sourceFolder;
@property(copy)NSNumber *steps;
@end
