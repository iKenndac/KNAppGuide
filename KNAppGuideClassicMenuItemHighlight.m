//
//  KNAppGuideClassicMenuItemHighlight.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 21/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideClassicMenuItemHighlight.h"

@interface KNAppGuideClassicMenuItemHighlight (Private)

-(NSRect)rectOfTopLevelMenuItem:(NSMenuItem *)anItem;
-(NSRect)rectOfAXUIElement:(AXUIElementRef)element;

@end

@implementation KNAppGuideClassicMenuItemHighlight

+(KNAppGuideClassicHighlight *)highlightForMenuItem:(NSMenuItem *)anItem {
	
	return [[[KNAppGuideClassicMenuItemHighlight alloc] initWithMenuItem:anItem] autorelease];
	
}

#pragma mark -

@synthesize menuItem;
@synthesize topLevelMenuItem;
@synthesize highlightedMenuItems;

-(id)initWithMenuItem:(NSMenuItem *)anItem {
	
	if (!anItem) {
		[self release];
		return nil;
	}
	
	// What to do?
	
	// Loop through the parent menus to find the menuItem tree
	
	NSMutableArray *menuItemsToHighlight = [[[NSMutableArray alloc] init] autorelease];
	
	NSMenuItem *currentMenuItem = anItem;
 	
	while (YES) {
		
		// Go up through the hierarchy 
		
		NSMenu *parent = [currentMenuItem menu];
		
		if (parent == [NSApp mainMenu]) {
			// Don't hightlight the top level item, 'cause it'll be circled
			break;
		} else if (parent == nil) {
			// Don't accept items that aren't in the main menu
			return nil;
		} else {
			[menuItemsToHighlight addObject:currentMenuItem];
		}
		
		for (NSMenuItem *item in [[parent supermenu] itemArray]) {
			if ([item submenu] == parent) {
				currentMenuItem = item;
			}
		}
		
	}
	
	NSRect menuItemRect = [self rectOfTopLevelMenuItem:currentMenuItem];
	
	if (NSEqualRects(menuItemRect, NSZeroRect)) {
		
		[self release];
		return nil;
		
	} else {
		
		NSView *phantomView = [[[NSView alloc] initWithFrame:menuItemRect] autorelease];
		
		if (self = [self initWithView:phantomView]) {
			
			[self setTopLevelMenuItem:currentMenuItem];
			[self setMenuItem:anItem];
			[self setHighlightedMenuItems:menuItemsToHighlight];
		
		}
		
		return self;
	}
	
}

#pragma mark -
#pragma mark AX Stuff

-(NSRect)rectOfTopLevelMenuItem:(NSMenuItem *)anItem {
	
	NSRect rect = NSZeroRect;
	
	if (![[[NSApp mainMenu] itemArray] containsObject:anItem]) {
		// Can't do this, dave.
		return rect;
	}
	
	AXUIElementRef appElementRef = AXUIElementCreateApplication([[NSProcessInfo processInfo] processIdentifier]);
	
	NSArray *array;
	AXUIElementRef menuBarRef;
	
	AXUIElementCopyAttributeValue(appElementRef, kAXMenuBarRole, (CFTypeRef *)&menuBarRef);
	
	if (menuBarRef) {
		
		AXUIElementCopyAttributeValue(menuBarRef, kAXChildrenAttribute, (CFTypeRef *)&array);
		
		for (id ref in array) {
			
			NSString *title;
			AXUIElementCopyAttributeValue((AXUIElementRef)ref, kAXTitleAttribute, (CFTypeRef *)&title);
			
			// Compare the AXUIElement to the given item by name. This sucks quite hard,
			// but I can't really see another way to do it.
			
			if ([[anItem title] isEqualToString:title]) {
				rect = [self rectOfAXUIElement:(AXUIElementRef)ref];
			}
			
			CFRelease(title);
		}
	}
	
	if (!NSEqualRects(rect, NSZeroRect)) {
		// Flip to match cocoa screen coordinates
		rect.origin.y = ([[[NSScreen screens] objectAtIndex:0] frame].size.height - rect.size.height);
	}
		
	CFRelease(appElementRef);
	CFRelease(menuBarRef);
	
	return rect;
}

-(NSRect)rectOfAXUIElement:(AXUIElementRef)element {
	
	NSRect rect = NSZeroRect;
	
	id elementPosition = nil;
	id elementSize = nil;
	
	if (AXUIElementCopyAttributeValue(element, kAXSizeAttribute, (CFTypeRef *)&elementSize) != kAXErrorSuccess) return NSZeroRect;
	if (AXUIElementCopyAttributeValue(element, kAXPositionAttribute, (CFTypeRef *)&elementPosition) != kAXErrorSuccess) return NSZeroRect;
	
	AXValueGetValue((AXValueRef)elementPosition, kAXValueCGPointType, &rect.origin);
	AXValueGetValue((AXValueRef)elementSize, kAXValueCGSizeType, &rect.size);
	
	CFRelease(elementPosition);
	CFRelease(elementSize);
	
	return rect;
}

-(void)setHighlightedMenuItems:(NSArray *)someItems {
	
	[someItems retain];
	
	for (NSMenuItem *item in [self highlightedMenuItems]) {
		[item setAttributedTitle:nil];
	}
	
	[highlightedMenuItems release];
	highlightedMenuItems = someItems;
	
	
	NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont menuFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
							 [NSColor redColor], NSForegroundColorAttributeName, nil];
	
	for (NSMenuItem *item in [self highlightedMenuItems]) {
		[item setAttributedTitle:[[[NSAttributedString alloc] initWithString:[item title] attributes:attribs] autorelease]];
	}
	
}

-(void)dealloc {
	
	[self setMenuItem:nil];
	[self setTopLevelMenuItem:nil];

	for (NSMenuItem *item in highlightedMenuItems) {
		[item setAttributedTitle:nil];
	}
	
	[highlightedMenuItems release];
	
	[super dealloc];
}

@end
