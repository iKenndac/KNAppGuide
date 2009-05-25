//
//  KNAppGuideClassicMenuItemHighlight.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 21/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KNAppGuideClassicHighlight.h"

@interface KNAppGuideClassicMenuItemHighlight : KNAppGuideClassicHighlight {

	NSArray *highlightedMenuItems;
	NSMenuItem *menuItem;
	NSMenuItem *topLevelMenuItem;
	
}


+(KNAppGuideClassicHighlight *)highlightForMenuItem:(NSMenuItem *)anItem;

-(id)initWithMenuItem:(NSMenuItem *)anItem;

@property (nonatomic, retain, readwrite) NSMenuItem *menuItem;
@property (nonatomic, retain, readwrite) NSMenuItem *topLevelMenuItem;
@property (nonatomic, retain, readwrite) NSArray *highlightedMenuItems;

@end
