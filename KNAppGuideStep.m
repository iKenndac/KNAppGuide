//
//  KNAppGuideStep.m
//  KNAppGuide
//
//  Created by Daniel Kennett on 07/05/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNAppGuideStep.h"
#import "KNAppGuideAction.h"

@implementation KNAppGuideStep

+(KNAppGuideStep *)stepWithExplanation:(NSString *)anExplanation action:(id <KNAppGuideAction>)anAction highlightedItem:(id)anItem {

	KNAppGuideStep *step = [[KNAppGuideStep alloc] init];
	
	[step setExplanation:anExplanation];
	[step setAction:anAction];
	[step setHighlightedItem:anItem];
	
	return [step autorelease];
}

@synthesize completionRequiredForNextStep;
@synthesize explanation;
@synthesize action;
@synthesize highlightedItem;

-(AppGuideActionResult)performAction {

	return [[self action] performActionForStep:self];
}

-(void)stepWillBeShown {
	
	// Here we'd do any preflight stuff - making sure the UI is in a state to receive our hightlights and actions, etc.
	
}

-(void)reset {

	[[self action] reset];
}



@end
