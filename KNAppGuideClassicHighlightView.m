//
//  KNAppGuideCircleHighlightView.m
//  CircleView
//
//  Created by Daniel Kennett on 12/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideClassicHighlightView.h"
#import <Quartz/Quartz.h>

@implementation KNAppGuideClassicHighlightView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // Initialization code here.
        [self setProgress:0.0];
        [self setIsRetro:NO];
        [self setLineWidth:15.0];
		
        [self addObserver:self
               forKeyPath:@"progress"
                  options:0
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"isRetro"
                  options:0
                  context:nil];
		
		[self addObserver:self
               forKeyPath:@"lineWidth"
                  options:0
                  context:nil];
        
        circleAnimation = [[NSAnimation alloc] initWithDuration:1.0
                                                        animationCurve:NSAnimationEaseOut];
		
        [circleAnimation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
        [circleAnimation setFrameRate:30.0];
        
        float marker = 0.0;
        float frameInterval = [circleAnimation duration] * [circleAnimation frameRate];
        
        for (marker == 0.0; marker <= 1.0; marker += 1.0 / frameInterval) {
            [circleAnimation addProgressMark:marker];
        }
        
        [circleAnimation setDelegate:self];
        [circleAnimation startAnimation];
        
    }
    return self;
}

- (void)animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)animationProgress {
    
    [self setProgress:animationProgress];
    
}

- (void)animationDidEnd:(NSAnimation *)animation {
    
    [self setProgress:1.0];
	[circleAnimation release];
	circleAnimation = nil;
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"progress"] || [keyPath isEqualToString:@"isRetro"] || [keyPath isEqualToString:@"lineWidth"]) {
        [self setNeedsDisplay:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@synthesize isRetro;
@synthesize progress;
@synthesize lineWidth;

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
    
	int steps = 100;
    int step = 0;
    float lineHeight = [self lineWidth];
    float animProgress = [self progress];
  
	float xRadius = (NSWidth([self bounds]) - (4 * lineHeight)) / 2;
    float yRadius = (NSHeight([self bounds]) - (4 * lineHeight)) / 2;
    
    NSPoint center = NSMakePoint(NSMidX([self bounds]), NSMidY([self bounds]));
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    for (step = 0; step <= steps; step++) {
		
        float progressRatio = (float)step / (float)steps;
        
        if (progressRatio > animProgress) {
            break;
        }
        
        float rad = progressRatio * 2.0 * pi;
        rad += pi / 2; // So we're starting from the top middle rather than the middle right
		float xSteps = cos(rad);
        float ySteps = sin(rad);
        
        NSPoint newPoint = NSMakePoint(center.x + xSteps * (xRadius + (progressRatio * (lineHeight / 2))),
                                       center.y + ySteps * (yRadius + (progressRatio * (lineHeight /2 ))));
        
        
        if (step == 0) {
            [path moveToPoint:NSMakePoint(newPoint.x + 5.0, newPoint.y)];
        } else if (step == steps) {
            [path lineToPoint:NSMakePoint(newPoint.x - 5.0, newPoint.y)];
        } else {
            [path lineToPoint:newPoint];
        }
		
        
    }
    
    [path setLineWidth:lineHeight];
    [path setLineCapStyle:NSRoundLineCapStyle];
	
    [[[NSColor redColor] colorWithAlphaComponent:0.75] set];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    if ([self isRetro]) {
        // Draw it up old-skool
        [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    } else {
        
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowBlurRadius:2.0];
        [shadow setShadowOffset:NSMakeSize(2.0, -2.0)];
        [shadow set];
        [shadow autorelease];
    }
    
	[path stroke];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];

}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"progress"];
    [self removeObserver:self forKeyPath:@"isRetro"];
    [self removeObserver:self forKeyPath:@"lineWidth"];
	
	if (circleAnimation) {
		[circleAnimation stopAnimation];
		[circleAnimation release];
		circleAnimation = nil;
    }
	
    [super dealloc];
}

@end
