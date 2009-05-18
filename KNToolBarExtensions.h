//
//  KNToolBarExtensions.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSToolbar (KNToolBarExtensions)

-(NSView *)viewForItem:(NSToolbarItem *)item;

-(NSToolbarItem *)itemWithIdentifier:(NSString *)identifier;

@end
