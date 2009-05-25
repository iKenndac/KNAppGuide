//
//  KNAppGuideClickButtonAction.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 08/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideClickButtonAction.h"


@implementation KNAppGuideClickButtonAction

+(KNAppGuideClickButtonAction *)actionForButton:(id)aButton {
	
	KNAppGuideClickButtonAction *action = [[KNAppGuideClickButtonAction alloc] init];
	
	if (aButton) {
		[action setButton:aButton];
	}
	
	return [action autorelease];
}

-(AppGuideActionResult)performActionForStep:(id <KNAppGuideStep>)step {
	
	if (actionButton && !hasClickedButton && [[self button] isEnabled]) {
		
		if ([[self button] isKindOfClass:[NSButton class]]) {
			[(NSButton *)[self button] performClick:nil];
		} else {
			[self actionButtonWasClicked:[self button]];
		}
			
		return kAppGuideActionSuccessful;
	} else if (hasClickedButton) {
		return kAppGuideActionAlreadyCompleted;
		
	} else {
		return kAppGuideActionFailed;
	}

}

#pragma mark -
#pragma mark KUNG-FU

-(IBAction)actionButtonWasClicked:(id)sender {
	
	[self willChangeValueForKey:@"hasBeenPerformed"];
	
	if (!buttonTarget) {
		[NSApp sendAction:buttonAction to:nil from:[self button]];
	} else {
		[buttonTarget performSelector:buttonAction withObject:sender];
	}
	
	hasClickedButton = YES;	
	
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(void)setButton:(id)aButton {
	
	/* 
	 Here, we redirect the button's target and action to self,
	 so we can tell when the user performs this step's action.
	 
	 The original target and action is stored, so we can still trigger them 
	 when the button is clicked.
	 
	 */
	
	if (actionButton) {
		[actionButton setTarget:buttonTarget];
		[buttonTarget release];
		buttonTarget = nil;
		[actionButton setAction:buttonAction];
		buttonAction = nil;
	}
	
	[aButton retain];
	
	[actionButton release];
	actionButton = nil;
	
	buttonTarget = [[aButton target] retain];
	[aButton setTarget:self];
	buttonAction = [aButton action];
	[aButton setAction:@selector(actionButtonWasClicked:)];
	
	actionButton = aButton;
	
	
}

-(id)button {
	return actionButton;
}

-(void)reset {
	[self willChangeValueForKey:@"hasBeenPerformed"];
	hasClickedButton = NO;
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(BOOL)hasBeenPerformed {
	return hasClickedButton;
}

-(void)dealloc {
	
	[self setButton:nil];
		
	[super dealloc];
}

@end
