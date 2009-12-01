//
//  FileEditController.m
//  IPLabFileOrganizer
//
//  Created by Anthony Kirwan on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileEditController.h"
#import "FileModel.h"
#import "AlertMessage.h"

@implementation FileEditController
@synthesize folderExists, fileModel, alert;

- (void)controlTextDidChange:(NSNotification *)aNotification 
{
	self.folderExists = [FileModel folderExists:
						 [[aNotification object] stringValue]];
	if (self.folderExists) 
	{
		[[aNotification object] setTextColor:[NSColor blackColor]];
	} else {
		[[aNotification object] setTextColor:[NSColor redColor]];
	}
}

- (void)finishedProcessing
{
	[startButton setEnabled:YES];
	//[progress setHidden:];
	//[completedText setHidden:YES];
}

- (IBAction)startProcessing:(id)sender 
{
	if (self.folderExists && [steps intValue] > 0) 
	{
		[startButton setEnabled:NO];
		[progress setHidden:NO];
		[self.fileModel startProcessingFromDir:[sourceFolder stringValue]
									steps:[steps stringValue]];
		[self finishedProcessing];
	}
	else if (!self.folderExists)
	{
		NSString *message = [NSString stringWithFormat:
							 @"The folder '%@' does not exits.\n Processing has been cancelled", [sourceFolder stringValue]];

		[alert showAlert:message];	
	} 
	else 
	{
		[alert showAlert:@"The steps must be greater than 0 for processing."];
	}

}

- (IBAction)cancelProcessing:(id)sender 
{
	[self.fileModel setContinueProcessing:NO];
}

- (void)updateProgress:(NSUInteger)completed {
	NSLog(@"%qu", completed);
	NSLog(@"%f", ((completed / [self.fileModel steps]) * 100.0));
	[progress setDoubleValue:((completed / [self.fileModel steps]) * 100.0)];
}


- (void)awakeFromNib 
{
	NSLog(@"awake from nib");	
}

- (id)init 
{
	if (self = [super init]) {
		self.folderExists = NO;
		self.fileModel = [[FileModel alloc] init];
		self.fileModel.delegate = self;
		self.alert = [[AlertMessage alloc] init];
		NSLog(@"init");
	}
	return self;
}

@end