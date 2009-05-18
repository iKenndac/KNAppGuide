//
//  KNAppGuidePerformSelectorAction.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 14/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuidePerformSelectorAction.h"


@implementation KNAppGuidePerformSelectorAction

@synthesize target;
@synthesize action;

+(KNAppGuidePerformSelectorAction *)actionForTarget:(id)aTarget action:(NSString *)anAction {
	
	KNAppGuidePerformSelectorAction *newAction = [[KNAppGuidePerformSelectorAction alloc] init];
	
	[newAction setTarget:aTarget];
	[newAction setAction:anAction];
	
	return [newAction autorelease];
}


-(AppGuideActionResult)performActionForStep:(id <KNAppGuideStep>)step {
	
	if ([self target] && [self action] && !actionWasPerformed) {
		
		[self willChangeValueForKey:@"hasBeenPerformed"];
		
		SEL actionSelector = NSSelectorFromString([self action]);
		[[self target] performSelector:actionSelector withObject:nil];
		
		[self didChangeValueForKey:@"hasBeenPerformed"];
		
		return kAppGuideActionSuccessful;
		
	} else if (actionWasPerformed) {
		return kAppGuideActionAlreadyCompleted;
		
	} else {
		return kAppGuideActionFailed;
	}
}

-(BOOL)hasBeenPerformed {
	return actionWasPerformed;
}

-(void)reset {
	[self willChangeValueForKey:@"hasBeenPerformed"];
	actionWasPerformed = NO;
	[self didChangeValueForKey:@"hasBeenPerformed"];
}

-(void)dealloc {
	[self setTarget:nil];
	[self setAction:nil];
	
	[super dealloc];
}

@end
