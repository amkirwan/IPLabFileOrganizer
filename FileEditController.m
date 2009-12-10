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
@synthesize folderExists;
@synthesize fileModel;
@synthesize alert;

- (id)init 
{
	if (self = [super init]) {
		self.folderExists = NO;
		self.fileModel = [[FileModel alloc] init];
		self.fileModel.delegate = self;
		self.alert = [[AlertMessage alloc] init];
	}
	return self;
}

- (void)controlTextDidChange:(NSNotification *)aNotification 
{
	self.folderExists = [FileModel folderExists:
						 [[aNotification object] stringValue]];
	NSLog(@"%@", [aNotification name]);
	NSLog(@"%@", [[aNotification object] stringValue]);
	if (self.folderExists) 
	{
		[[aNotification object] setTextColor:[NSColor blackColor]];
	} else {
		[[aNotification object] setTextColor:[NSColor redColor]];
	}
}

- (void)finishedProcessing:(NSString *)message
{
	[startButton setEnabled:YES];
	[cancelButton setEnabled:NO];
	[progress setHidden:YES];
	[completedText setHidden:YES];	
	[alert showAlert:message heading:@"Finished"];
	self.fileModel.isProcessing = NO;

}

- (void)updateProgress:(NSNumber *)completed 
{
	//NSLog(@"%qu", completed);
	//NSLog(@"%f", ((compf / [self.fileModel steps]) * 100.0));
	float compf = [completed floatValue];	
	[progress setDoubleValue:((compf / [self.fileModel steps]) * 100.0)];
	[progress displayIfNeeded];
	[completedText setStringValue:[NSString stringWithFormat:@"Completed: %qu of %qu", [completed integerValue], [self.fileModel steps]]];
	[completedText displayIfNeeded];
}

// IBActions
- (IBAction)startProcessing:(id)sender 
{
	if (self.folderExists && [steps intValue] > 0) 
	{
		
		[startButton setEnabled:NO];
		[cancelButton setEnabled:YES];
		[progress setHidden:NO];
		[completedText setHidden:YES];
		[self.fileModel startProcessingFromDir:[sourceFolder stringValue]
									steps:[steps stringValue]];
	}
	else if (!self.folderExists)
	{
		[alert showAlert:[NSString stringWithFormat:
				@"The folder '%@' does not exits.\n Processing has been cancelled", [sourceFolder stringValue]] 
				 heading:@"Warning"];	
	} 
	else 
	{
		[alert showAlert:@"The steps must be greater than 0 for processing."
	             heading:@"Warning"];
	}
}

- (IBAction)cancelProcessing:(id)sender 
{
	[self.fileModel cancelAll];
}

- (IBAction)openFile:(id)sender
{
	NSLog(@"openPanel");
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	[oPanel setCanChooseDirectories:YES];
	[oPanel	setCanChooseFiles:NO];
	//[oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	//NSInteger result = [oPanel runModal];
	NSInteger result = [oPanel runModalForDirectory:NSHomeDirectory() file:nil
									types:nil];
	
	
	if (result == NSOKButton) 
	{
		NSArray *folderToOpen = [oPanel URLs];
		NSURL *url = [NSURL fileURLWithPath:[[folderToOpen objectAtIndex:0] relativePath]];
		[sourceFolder setStringValue:[url path]];
		[[NSNotificationCenter defaultCenter] 
		 postNotificationName:@"NSControlTextDidChangeNotification"
		 object:sourceFolder];
	}
}

- (void)awakeFromNib
{
	[cancelButton setEnabled:NO];
}

@end