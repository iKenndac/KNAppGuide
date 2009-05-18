//
//  KNAppGuideClassicControlHighlight.h
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNAppGuide/KNAppGuideClassicHighlightView.h>

@interface KNAppGuideClassicHighlight : NSWindow {
	NSView *view;
	KNAppGuideClassicHighlightView *highlightView;
}

+(KNAppGuideClassicHighlight *)highlightForItem:(id)item;
+(KNAppGuideClassicHighlight *)highlightForView:(NSView *)aView;

-(id)initWithView:(NSView *)aView;

@property (readonly, nonatomic) NSView *view;
-(void)positionOverView;

@end
