//
//  AlertMessage.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlertMessage.h"


@implementation AlertMessage

- (void)showAlert:(NSString *)text 
{
	NSAlert *alert = [NSAlert alertWithMessageText:@"Warning"
									 defaultButton:@"Ok" 
								   alternateButton:nil 
									   otherButton:nil
						 informativeTextWithFormat:text];
	
	[alert beginSheetModalForWindow:window modalDelegate:self 
					 didEndSelector:nil contextInfo:nil];	
	
}

@end
