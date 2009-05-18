//
//  KNToolBarExtensions.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNToolBarExtensions.h"


@implementation NSToolbar (KNToolBarExtensions)

-(NSView *)viewForItem:(NSToolbarItem *)item {
	
	// This uses private APIs - boo! :-(
	
	if (![[self items] containsObject:item]) {
		return nil;
	}
	
	@try {
		NSView *toolbarView = [self valueForKey:@"_toolbarView"];
		NSArray *toolbarItemViews = [[[toolbarView subviews] objectAtIndex:0] subviews];
		
		for (NSView *toolbarItemView in toolbarItemViews) {
			if ([toolbarItemView valueForKey:@"_item"] == item) {
				return toolbarItemView;
			}
		}
		
	}
	@catch (NSException * e) {
		return nil;
	}
		
	return nil;
}


-(NSToolbarItem *)itemWithIdentifier:(NSString *)identifier {
	
	// This is to get around what seems to be a bug - if you connect an IBOutlet to 
	// a "built-in" toolbar item (NSToolbarCustomizeToolbarItemIdentifier, etc) on an 
	// IB-made toolbar, the item  gets copied into the toolbar and the instance we connected 
	// to doesn't have -toolbar set. 
	// Therefore, we get the items out of the toolbar like this and set the references manually.
	
	for (NSToolbarItem *item in [self items]) {
		if ([[item itemIdentifier] isEqualToString:identifier]) {
			return item;
		}
	}
	
	return nil;
}

@end
