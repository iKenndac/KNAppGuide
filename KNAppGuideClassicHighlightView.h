//
//  KNAppGuideCircleHighlightView.h
//  CircleView
//
//  Created by Daniel Kennett on 12/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KNAppGuideClassicHighlightView : NSView {
    CGFloat progress;
	CGFloat lineWidth;
    BOOL isRetro;
	
	NSAnimation *circleAnimation;
}

@property CGFloat progress; // The progress of the animation, from 0.0 to 1.0. 
@property CGFloat lineWidth;
@property BOOL isRetro; // If set to YES, the highlight will be drawn without shadows or antialiasing to give that suave System 7 look.

@end
