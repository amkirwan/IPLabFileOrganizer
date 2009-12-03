//
//  AlertMessage.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlertMessage.h"


@implementation AlertMessage

- (void)showAlert:(NSString *)text heading:(NSString *)message
{
	NSAlert *alert = [NSAlert alertWithMessageText:message
									 defaultButton:@"Ok" 
								   alternateButton:nil 
									   otherButton:nil
						 informativeTextWithFormat:text];
	
	[alert beginSheetModalForWindow:window modalDelegate:self 
					 didEndSelector:nil contextInfo:nil];	
	
}

- (id)init
{
	if(self = [super init]) return self;
}

@end
