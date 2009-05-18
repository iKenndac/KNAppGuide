//
//  KNAppGuideClassicControlHighlight.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideClassicHighlight.h"
#import "KNAppGuideClassicHighlightView.h"
#import "KNToolBarExtensions.h"

@implementation KNAppGuideClassicHighlight

+(KNAppGuideClassicHighlight *)highlightForItem:(id)item {
	
	if ([item isKindOfClass:[NSView class]]) {
		return [KNAppGuideClassicHighlight highlightForView:item];
	} else if ([item isKindOfClass:[NSToolbarItem class]]) {
		return [KNAppGuideClassicHighlight highlightForView:[[item toolbar] viewForItem:item]];
	} else {
		return nil;
	}
	
}

+(KNAppGuideClassicHighlight *)highlightForView:(NSView *)aView {
	
	if ([aView isHiddenOrHasHiddenAncestor]) {
		// Can't highlight a hidden view!
		return nil;
	}
	
	return [[[KNAppGuideClassicHighlight alloc] initWithView:aView] autorelease];
 }

-(id)initWithView:(NSView *)aView {
	
	// Insist on having a valid view.
    if (!aView) {
        return nil;
    }
	
	view = [aView retain];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(viewFrameDidChange:) 
												 name:NSViewFrameDidChangeNotification
											   object:[self view]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(viewFrameDidChange:) 
												 name:NSViewFrameDidChangeNotification
											   object:[[self view] superview]];
	
	highlightView = [[KNAppGuideClassicHighlightView alloc] initWithFrame:NSZeroRect];
	
	if (self = [super initWithContentRect:NSZeroRect 
								styleMask:NSBorderlessWindowMask 
								  backing:NSBackingStoreBuffered 
									defer:NO]) {
		
		NSDisableScreenUpdates();
		
		[[self contentView] addSubview:highlightView];
		
		[self setBackgroundColor:[NSColor clearColor]];
		[self setAlphaValue:1.0];
		[self setIgnoresMouseEvents:YES];
		[self setExcludedFromWindowsMenu:YES];
		[self setOpaque:NO];
		
		[self positionOverView];	
		
		
		[[aView window] addChildWindow:self ordered:NSWindowAbove];
		
		NSEnableScreenUpdates();
	}
	
	return self;
	
	
}

@synthesize view;

-(void)viewFrameDidChange:(NSNotification *)notification {
	
	[self positionOverView];
	
}

-(void)positionOverView {
	
	NSDisableScreenUpdates();
	
	[[self parentWindow] removeChildWindow:self];
	[self orderOut:self];
	
	NSRect contentRect = NSZeroRect;
	contentRect.size = [[self view] frame].size;
	contentRect.size.width += (5 * [highlightView lineWidth]); 
	contentRect.size.height += (5 * [highlightView lineWidth]);
	// ^ Expand the frame so we can fit our highlight sensibly around the control.
	// "5 * lineWidth" seems a little arbitrary, but setting it to (say) double the highlighted view's 
	// dimensions starts to fail when you highlight large controls.
	
	NSRect viewFrame = [[[self view] superview] convertRectToBase:[[self view] frame]]; 
	NSPoint controlOriginInScreenSpace = [[[self view] window] convertBaseToScreen:viewFrame.origin];
	
	NSPoint frameOrigin = NSMakePoint(controlOriginInScreenSpace.x + ((viewFrame.size.width / 2) - (contentRect.size.width / 2)), 
									  controlOriginInScreenSpace.y + ((viewFrame.size.height / 2) - (contentRect.size.height / 2)));
	
	frameOrigin.y += 2.0; // Nudge the highlight up a bit to counter that the highlight oval is slightly off-centre
	
	contentRect.origin = frameOrigin;
	[self setFrame:contentRect display:NO];
	[highlightView setFrame:[[self contentView] bounds]];
	
	[[[self view] window] addChildWindow:self ordered:NSWindowAbove];
	
	NSEnableScreenUpdates();
}

-(void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:[self view]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:[[self view] superview]];
	
	[view release];
	view = nil;
	[highlightView release];

	if ([self parentWindow]) {
		[[self parentWindow] removeChildWindow:self];
	}
	
	[super dealloc];
	
}

@end
