//
//  AlertMessage.h
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AlertMessage : NSObject {
	IBOutlet NSWindow *window;
}

- (void)showAlert:(NSString *)text;
@end
