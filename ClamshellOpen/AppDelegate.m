//
//  AppDelegate.m
//  ClamshellOpen
//
//  Created by Seph Soliman on 11/01/13.
//  Copyright (c) 2013 Seph Soliman. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id) init
{
	//We need to be our own delegate
	if(self = [super init])
		[self setDelegate:self];
	
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self setDisplay:CGMainDisplayID()];
	
	CGCaptureAllDisplays();
	
	//uint32_t numDisplays = -1;
	//CGGetActiveDisplayList(32, nil, &numDisplays);
	
	CGContextRef context = CGDisplayGetDrawingContext([self display]);
	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
	[NSGraphicsContext setCurrentContext:nsGraphicsContext];
	//[NSGraphicsContext saveGraphicsState];
	
	CGDisplayModeRef modeRef = CGDisplayCopyDisplayMode([self display]);
	unsigned long displayWidth = CGDisplayModeGetWidth(modeRef);
	unsigned long displayHeight = CGDisplayModeGetHeight(modeRef);
	CGDisplayModeRelease(modeRef);

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setAlignment:NSCenterTextAlignment];
	NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
									[NSFont systemFontOfSize:16.0],
									NSFontAttributeName,
									[NSColor whiteColor],
									NSForegroundColorAttributeName,
									style,
									NSParagraphStyleAttributeName,
									nil];
	
	
	NSRect aRect = NSMakeRect(0.0, displayHeight / 2, displayWidth, 40.0);
	

	//[@"Open the lid. Press escape (or wait 10 seconds)." drawInRect: aRect withAttributes:textAttributes];
	[@"Open the lid. Press escape (or wait 10 seconds)." drawWithRect:aRect options:NSStringDrawingTruncatesLastVisibleLine attributes:textAttributes];
	//[NSGraphicsContext restoreGraphicsState];
	
	[NSTimer scheduledTimerWithTimeInterval: 10.0 target:self selector:@selector(autoClose:) userInfo:nil repeats:NO];
}

- (void) sendEvent:(NSEvent *)theEvent
{
	if((theEvent.type == NSKeyDown && theEvent.keyCode == 53) ||
	   (theEvent.type == NSLeftMouseDown)) {
		NSLog(@"User action. Closing.");
		[self close];
	}
}

- (void) applicationWillTerminate:(NSNotification*)aNotification
{
	[self close];
}

- (void) autoClose:(NSTimer*)theTimer
{
	NSLog(@"Timeout. Closing.");
	[self close];
}

- (void) close
{
	CGReleaseAllDisplays();
	[self terminate:nil];
}

@end
